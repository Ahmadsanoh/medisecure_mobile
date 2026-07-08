// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'MediSecure';

  @override
  String get connexion => 'Connexion';

  @override
  String get loginEmail => 'Adresse email';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginSubmit => 'Se connecter';

  @override
  String get loginNoAccount => 'Pas encore de compte ? ';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Tout lire';

  @override
  String get notificationsEmpty => 'Aucune notification';

  @override
  String get notificationsEmptySub =>
      'Vous serez informé dès qu\'il y aura du nouveau.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navAppointments => 'RDV';

  @override
  String get navRecords => 'Dossier';

  @override
  String get navNotifications => 'Alertes';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeWelcome => 'Bonjour';

  @override
  String get homeWelcomePatient => 'Bonjour 👋';

  @override
  String get homeUpcomingAppointments => 'Prochains rendez-vous';

  @override
  String get homeNoAppointments => 'Aucun rendez-vous à venir';

  @override
  String get homeTotalAppts => 'RDV total';

  @override
  String get homeConfirmed => 'Confirmés';

  @override
  String get homePending => 'En attente';

  @override
  String get homeAlerts => 'Alertes';

  @override
  String get homeQuickActions => 'Actions rapides';

  @override
  String get homeBookAppt => 'Prendre RDV';

  @override
  String get homeMyRecords => 'Mon dossier';

  @override
  String get homeQrCode => 'QR Code';

  @override
  String get homeHistory => 'Historique';

  @override
  String get homeNextAppt => 'Prochain rendez-vous';

  @override
  String get homeMyAppts => 'Mes rendez-vous';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeQrTitle => 'Mon QR Code Patient';

  @override
  String get homeQrSub => 'Présentez ce code à votre médecin.';

  @override
  String get homeNoApptsToday => 'Aucun RDV aujourd\'hui';

  @override
  String get homePatientsToday => 'Patients aujourd\'hui';

  @override
  String get actionPostpone => 'Reporter';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDetails => 'Détails';

  @override
  String get actionBook => 'Prendre rendez-vous';

  @override
  String get homePrescriptions => 'Ordonnance';

  @override
  String get homeStats => 'Stats';

  @override
  String get adminManageUsers => 'Gérer les utilisateurs';

  @override
  String get adminActivityLogs => 'Journaux d\'activité';

  @override
  String get adminRbac => 'Rôles & Permissions (RBAC)';

  @override
  String get adminAnalytics => 'Rapports & Analytics';

  @override
  String get adminSystemSettings => 'Paramètres système';

  @override
  String get retry => 'Réessayer';

  @override
  String get error => 'Erreur';

  @override
  String get settingsMonCompte => 'Mon compte';

  @override
  String get settingsSecurite => 'Sécurité';

  @override
  String get settingsPreferences => 'Préférences';

  @override
  String get settingsLangue => 'Langue';

  @override
  String get settingsChangerLangue => 'Changer la langue';

  @override
  String get settingsEn => 'Anglais';

  @override
  String get settingsFr => 'Français';

  @override
  String get settingsDeconnexion => 'Se déconnecter';

  @override
  String get errorGeneric => 'Une erreur est survenue lors du chargement.';

  @override
  String get errorConnection =>
      'Problème de connexion. Vérifiez votre internet.';

  @override
  String get errorSession =>
      'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errorForbidden => 'Accès non autorisé.';

  @override
  String get errorNotFound => 'Ressource introuvable.';

  @override
  String get apptsUpcoming => 'À venir';

  @override
  String get apptsPast => 'Passés';

  @override
  String get apptsCancelled => 'Annulés';

  @override
  String get apptsNone => 'Aucun rendez-vous';

  @override
  String get recordsTitle => 'Dossier médical';

  @override
  String get recordsEncrypted => 'Chiffré';

  @override
  String get recordsPersonalInfo => 'Informations personnelles';

  @override
  String get recordsAntecedents => 'Antécédents';

  @override
  String get recordsAllergies => 'Allergies';

  @override
  String get recordsPrescriptions => 'Ordonnances actives';

  @override
  String get recordsConsultations => 'Historique consultations';

  @override
  String get recordsLabResults => 'Résultats d\'analyses';

  @override
  String get recordsAddNote => 'Ajouter une note médicale';

  @override
  String get recordsMedicalNote => 'Note médicale';

  @override
  String get recordsDiagnostic => 'Diagnostic';

  @override
  String get recordsObservations => 'Observations';

  @override
  String get recordsSave => 'Enregistrer';

  @override
  String get recordsId => 'ID dossier';

  @override
  String get recordsCreatedAt => 'Créé le';

  @override
  String get recordsNone => 'Aucune information renseignée.';

  @override
  String get recordsNoPrescr => 'Aucune ordonnance active.';

  @override
  String get recordsUntil => 'Jusqu\'au';

  @override
  String get recordsNoConsult => 'Aucune consultation enregistrée.';

  @override
  String get recordsNoLab => 'Aucun résultat disponible.';

  @override
  String get profilePhone => 'Téléphone';

  @override
  String get profileNotSet => 'Non renseigné';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get profile2fa => 'Double authentification (2FA)';

  @override
  String get profileActivityLog => 'Journal d\'activité';

  @override
  String get profilePushNotif => 'Notifications push';

  @override
  String get profileEmailReminders => 'Rappels par email';

  @override
  String get profileDanger => 'Danger';

  @override
  String get profileDeleteAccount => 'Supprimer mon compte';

  @override
  String get profileDeleteConfirm => 'Supprimer le compte ?';

  @override
  String get profileDeleteMessage =>
      'Toutes vos données seront supprimées définitivement.';

  @override
  String get profileDeleteAction => 'Supprimer';

  @override
  String get profileActionRequired => 'Action requise';

  @override
  String get profileContactAdmin =>
      'Contactez un administrateur pour supprimer votre compte.';

  @override
  String get roleAdmin => '🛡️ Administrateur';

  @override
  String get roleDoctor => '👨‍⚕️ Médecin';

  @override
  String get rolePatient => '🧑 Patient';

  @override
  String get profileEdit => 'Modifier le profil';

  @override
  String get profileFirstName => 'Prénom';

  @override
  String get profileLastName => 'Nom';

  @override
  String get profileSpecialty => 'Spécialité';

  @override
  String get profileCabinet => 'Cabinet / Clinique';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get bookingTitle => 'Prendre rendez-vous';

  @override
  String get bookingStepSpecialty => 'Spécialité';

  @override
  String get bookingStepDoctor => 'Médecin';

  @override
  String get bookingStepSlot => 'Créneau';

  @override
  String get bookingStepConfirm => 'Confirmation';

  @override
  String get bookingLoadingSpecialties => 'Chargement des spécialités...';

  @override
  String get bookingSelectSpecialty => 'Choisissez une spécialité';

  @override
  String get bookingLoadingDoctors => 'Recherche des médecins...';

  @override
  String bookingSelectDoctorIn(String specialty) {
    return 'Choisissez un médecin en $specialty';
  }

  @override
  String get bookingNoDoctors =>
      'Aucun médecin disponible pour cette spécialité.';

  @override
  String get bookingSelectSlot => 'Choisissez un créneau';

  @override
  String get bookingAvailableSlots => 'Créneaux disponibles';

  @override
  String get bookingLoadingSlots => 'Récupération des créneaux...';

  @override
  String get bookingNoSlots => 'Aucun créneau disponible pour cette date.';

  @override
  String get bookingConfirmTitle => 'Confirmer le rendez-vous';

  @override
  String get bookingLabelDate => 'Date';

  @override
  String get bookingLabelTime => 'Heure';

  @override
  String get bookingLabelDuration => 'Durée';

  @override
  String get bookingDurationValue => '30 minutes';

  @override
  String get bookingLabelMotif => 'Motif (optionnel)';

  @override
  String get bookingHintMotif => 'Ex: Douleur thoracique, bilan annuel...';

  @override
  String get bookingActionNext => 'Suivant →';

  @override
  String get bookingActionConfirm => '✓ Confirmer le rendez-vous';

  @override
  String get bookingSuccess => 'Rendez-vous réservé avec succès !';

  @override
  String get bookingError => 'Impossible de réserver ce créneau.';

  @override
  String get roleNurse => '🩺 Infirmier(ère)';

  @override
  String get homeManagement => 'Gestion';

  @override
  String get logoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get logoutConfirmMessage =>
      'Voulez-vous vraiment fermer votre session ?';

  @override
  String get bookingConfirmAction => 'Confirmer la réservation';

  @override
  String get bookingConfirmMessage => 'Voulez-vous confirmer ce rendez-vous ?';

  @override
  String get saveConfirmTitle => 'Enregistrer les modifications ?';

  @override
  String get saveConfirmMessage => 'Vos informations seront mises à jour.';

  @override
  String get prescriptionConfirmTitle => 'Émettre l\'ordonnance ?';

  @override
  String get prescriptionConfirmMessage =>
      'L\'ordonnance sera envoyée au patient.';
}
