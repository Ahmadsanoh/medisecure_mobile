import uuid

from django.utils import timezone
from drf_spectacular.utils import extend_schema
from rest_framework.response import Response
from rest_framework.views import APIView

from medisecure.users.models import LogActivite, User, Patient, Medecin, Admin, Roles
from medisecure.users.permissions import IsAppAdmin
from medisecure.rdv.models import RendezVous, StatutRDV


class LogActiviteListView(APIView):
    """Consulter logs d'activité (Admin seulement)"""

    permission_classes = [IsAppAdmin]

    @extend_schema(
        responses={200: None},
        summary="Consulter les logs d'activité (Admin)",
        tags=["Administration"],
    )
    def get(self, request):
        logs = LogActivite.objects.select_related("utilisateur").order_by(
            "-date_action"
        )[:100]
        return Response(
            [
                {
                    "id": log.id,
                    "user_id": log.utilisateur_id,
                    "utilisateur": log.utilisateur.email,
                    "action": log.action,
                    "adresse_ip": log.adresse_ip,
                    "date_action": log.date_action,
                }
                for log in logs
            ]
        )


class UserRoleUpdateView(APIView):
    """Attribuer rôles et permissions"""

    permission_classes = [IsAppAdmin]

    @extend_schema(
        request=None,
        responses={200: None},
        summary="Changer le rôle d'un utilisateur",
        tags=["Administration"],
    )
    def patch(self, request, user_id: int):
        role = request.data.get("role")
        if role not in [Roles.PATIENT, Roles.MEDECIN, Roles.INFIRMIER, Roles.ADMIN]:
            return Response({"detail": "Rôle invalide."}, status=400)
        try:
            user = User.objects.get(id=user_id)
            user.role = role
            user.save()
            return Response({"id": user.id, "email": user.email, "role": user.role})
        except User.DoesNotExist:
            return Response({"detail": "Utilisateur introuvable."}, status=404)


# ---------------------------------------------------------------------------
# Mapping entre les rôles "métier" (backend, majuscules françaises) et la
# convention utilisée côté mobile (minuscules anglaises). Voir aussi
# UserModel._normalizeRole côté Flutter.
# ---------------------------------------------------------------------------
_ROLE_MOBILE_TO_BACKEND = {
    "patient": Roles.PATIENT,
    "doctor": Roles.MEDECIN,
    "nurse": Roles.INFIRMIER,
    "admin": Roles.ADMIN,
}
_ROLE_BACKEND_TO_MOBILE = {v: k for k, v in _ROLE_MOBILE_TO_BACKEND.items()}


def _serialize_user_for_admin(user: User) -> dict:
    return {
        "id": user.id,
        "nom": user.nom,
        "prenom": user.prenom,
        "email": user.email,
        "telephone": user.telephone,
        "role": user.role,
        "statut": user.statut,  # email vérifié (bool)
        "is_active": user.is_active,  # compte actif / suspendu
        "date_joined": user.date_joined.isoformat() if user.date_joined else None,
        "last_login": user.last_login.isoformat() if user.last_login else None,
    }


class AdminStatsView(APIView):
    """Statistiques globales pour le tableau de bord admin (mobile + web)."""

    permission_classes = [IsAppAdmin]

    @extend_schema(
        responses={200: None},
        summary="Statistiques globales (Admin)",
        tags=["Administration"],
    )
    def get(self, request):
        today = timezone.localdate()
        total_users = User.objects.count()
        active_doctors = User.objects.filter(
            role=Roles.MEDECIN, is_active=True
        ).count()
        appointments_today = RendezVous.objects.filter(
            date_heure__date=today
        ).count()
        pending_appointments = RendezVous.objects.filter(
            statut=StatutRDV.EN_ATTENTE
        ).count()

        return Response(
            {
                "total_users": total_users,
                "active_doctors": active_doctors,
                "appointments_today": appointments_today,
                "pending_appointments": pending_appointments,
                # Champs additionnels (utiles pour un futur écran Analytics)
                "total_patients": User.objects.filter(role=Roles.PATIENT).count(),
                "total_medecins": User.objects.filter(role=Roles.MEDECIN).count(),
                "total_infirmiers": User.objects.filter(
                    role=Roles.INFIRMIER
                ).count(),
                "total_admins": User.objects.filter(role=Roles.ADMIN).count(),
                "total_rdv": RendezVous.objects.count(),
                "rdv_confirmes": RendezVous.objects.filter(
                    statut=StatutRDV.CONFIRME
                ).count(),
                "rdv_annules": RendezVous.objects.filter(
                    statut=StatutRDV.ANNULE
                ).count(),
                "rdv_termines": RendezVous.objects.filter(
                    statut=StatutRDV.TERMINE
                ).count(),
            }
        )


class AdminUserListCreateView(APIView):
    """Lister tous les utilisateurs / en créer un nouveau (Admin seulement)."""

    permission_classes = [IsAppAdmin]

    @extend_schema(
        responses={200: None},
        summary="Lister tous les utilisateurs (Admin)",
        tags=["Administration"],
    )
    def get(self, request):
        users = User.objects.all().order_by("-date_joined")
        return Response([_serialize_user_for_admin(u) for u in users])

    @extend_schema(
        request=None,
        responses={201: None, 400: None},
        summary="Créer un utilisateur (Admin)",
        tags=["Administration"],
    )
    def post(self, request):
        data = request.data
        email = (data.get("email") or "").strip().lower()
        nom = (data.get("nom") or "").strip()
        prenom = (data.get("prenom") or "").strip()
        password = data.get("password") or uuid.uuid4().hex[:12]
        role_in = (data.get("role") or "patient").strip().lower()
        role = _ROLE_MOBILE_TO_BACKEND.get(role_in, role_in.upper())

        if not email:
            return Response({"detail": "Email requis."}, status=400)
        if role not in Roles.values:
            return Response({"detail": f"Rôle invalide : {role_in}"}, status=400)
        if User.objects.filter(email=email).exists():
            return Response({"detail": "Cet email est déjà utilisé."}, status=400)

        user = User.objects.create_user(
            email=email,
            password=password,
            nom=nom,
            prenom=prenom,
            role=role,
            statut=True,  # créé par un admin : pas besoin de vérifier l'email
        )

        # Le profil Patient/Médecin est déjà créé automatiquement par le
        # signal post_save sur User (voir users/signals.py). On ne gère
        # ici que le rôle ADMIN, qui n'est pas couvert par ce signal, et on
        # complète le numéro de licence du médecin s'il a été fourni.
        if role == Roles.MEDECIN and data.get("numero_licence"):
            Medecin.objects.filter(user=user).update(
                numero_licence=data["numero_licence"]
            )
        elif role == Roles.ADMIN:
            Admin.objects.get_or_create(user=user)

        LogActivite.objects.create(
            utilisateur=request.user,
            action=f"Création utilisateur : {email} (rôle: {role})",
            adresse_ip=request.META.get("REMOTE_ADDR"),
        )

        return Response(_serialize_user_for_admin(user), status=201)


class AdminUserDetailView(APIView):
    """Modifier / supprimer un utilisateur (Admin seulement)."""

    permission_classes = [IsAppAdmin]

    def _get_user(self, user_id: int):
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            return None

    @extend_schema(
        request=None,
        responses={200: None, 404: None},
        summary="Mettre à jour un utilisateur (Admin)",
        tags=["Administration"],
    )
    def put(self, request, user_id: int):
        return self._update(request, user_id)

    def patch(self, request, user_id: int):
        return self._update(request, user_id)

    def _update(self, request, user_id: int):
        user = self._get_user(user_id)
        if user is None:
            return Response({"detail": "Utilisateur introuvable."}, status=404)

        data = request.data

        if "nom" in data:
            user.nom = data["nom"]
        if "prenom" in data:
            user.prenom = data["prenom"]
        if "telephone" in data:
            user.telephone = data["telephone"]

        changes = []

        if "role" in data:
            role_in = str(data["role"]).strip().lower()
            role = _ROLE_MOBILE_TO_BACKEND.get(role_in, role_in.upper())
            if role not in Roles.values:
                return Response({"detail": f"Rôle invalide : {role_in}"}, status=400)
            if role != user.role:
                changes.append(f"rôle -> {role}")
            user.role = role

        # `statut` côté mobile peut arriver soit comme booléen (vérif email),
        # soit comme chaîne 'active'/'suspended' (ancienne convention UI) —
        # on ne traite dans ce champ QUE la vérification d'email. La
        # suspension d'un compte se fait via `is_active` (voir ci-dessous),
        # qui est le mécanisme natif Django (bloque réellement la connexion).
        if "statut" in data and isinstance(data["statut"], bool):
            user.statut = data["statut"]

        if "is_active" in data:
            user.is_active = bool(data["is_active"])
            changes.append("actif" if user.is_active else "suspendu")
        elif data.get("statut") == "suspended":
            user.is_active = False
            changes.append("suspendu")
        elif data.get("statut") == "active":
            user.is_active = True
            changes.append("actif")

        user.save()

        if changes:
            LogActivite.objects.create(
                utilisateur=request.user,
                action=f"Modification utilisateur {user.email} ({', '.join(changes)})",
                adresse_ip=request.META.get("REMOTE_ADDR"),
            )

        return Response(_serialize_user_for_admin(user))

    @extend_schema(
        responses={204: None, 404: None},
        summary="Supprimer un utilisateur (Admin)",
        tags=["Administration"],
    )
    def delete(self, request, user_id: int):
        user = self._get_user(user_id)
        if user is None:
            return Response({"detail": "Utilisateur introuvable."}, status=404)
        if user.id == request.user.id:
            return Response(
                {"detail": "Vous ne pouvez pas supprimer votre propre compte."},
                status=400,
            )
        email = user.email
        user.delete()
        LogActivite.objects.create(
            utilisateur=request.user,
            action=f"Suppression utilisateur : {email}",
            adresse_ip=request.META.get("REMOTE_ADDR"),
        )
        return Response(status=204)
