from rest_framework.permissions import BasePermission


class IsAppAdmin(BasePermission):
    """
    Autorise l'accès uniquement aux utilisateurs ayant le rôle métier ADMIN
    (ou aux comptes techniques Django is_staff/is_superuser, ex: créés via
    createsuperuser).

    On ne peut pas utiliser IsAdminUser de DRF ici : celui-ci vérifie
    uniquement `request.user.is_staff`, qui n'a rien à voir avec le rôle
    métier "ADMIN" attribué via l'app (les comptes admin créés depuis le
    panneau web ou l'API n'ont pas is_staff=True).
    """

    message = "Accès réservé aux administrateurs."

    def has_permission(self, request, view) -> bool:
        user = request.user
        if not (user and user.is_authenticated):
            return False
        return bool(
            getattr(user, "role", None) == "ADMIN"
            or user.is_staff
            or user.is_superuser
        )
