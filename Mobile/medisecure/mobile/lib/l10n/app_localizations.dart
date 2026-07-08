import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Le titre de l'application
  ///
  /// In fr, this message translates to:
  /// **'MediSecure'**
  String get appTitle;

  /// No description provided for @connexion.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connexion;

  /// No description provided for @loginEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get loginPassword;

  /// No description provided for @loginForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get loginForgotPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginSubmit;

  /// No description provided for @loginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? '**
  String get loginNoAccount;

  /// No description provided for @loginCreateAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get loginCreateAccount;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout lire'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get notificationsEmpty;

  /// No description provided for @notificationsEmptySub.
  ///
  /// In fr, this message translates to:
  /// **'Vous serez informé dès qu\'il y aura du nouveau.'**
  String get notificationsEmptySub;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navAppointments.
  ///
  /// In fr, this message translates to:
  /// **'RDV'**
  String get navAppointments;

  /// No description provided for @navRecords.
  ///
  /// In fr, this message translates to:
  /// **'Dossier'**
  String get navRecords;

  /// No description provided for @navNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get navNotifications;

  /// No description provided for @navProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @homeWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour'**
  String get homeWelcome;

  /// No description provided for @homeWelcomePatient.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get homeWelcomePatient;

  /// No description provided for @homeUpcomingAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Prochains rendez-vous'**
  String get homeUpcomingAppointments;

  /// No description provided for @homeNoAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous à venir'**
  String get homeNoAppointments;

  /// No description provided for @homeTotalAppts.
  ///
  /// In fr, this message translates to:
  /// **'RDV total'**
  String get homeTotalAppts;

  /// No description provided for @homeConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmés'**
  String get homeConfirmed;

  /// No description provided for @homePending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get homePending;

  /// No description provided for @homeAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get homeAlerts;

  /// No description provided for @homeQuickActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions rapides'**
  String get homeQuickActions;

  /// No description provided for @homeBookAppt.
  ///
  /// In fr, this message translates to:
  /// **'Prendre RDV'**
  String get homeBookAppt;

  /// No description provided for @homeMyRecords.
  ///
  /// In fr, this message translates to:
  /// **'Mon dossier'**
  String get homeMyRecords;

  /// No description provided for @homeQrCode.
  ///
  /// In fr, this message translates to:
  /// **'QR Code'**
  String get homeQrCode;

  /// No description provided for @homeHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get homeHistory;

  /// No description provided for @homeNextAppt.
  ///
  /// In fr, this message translates to:
  /// **'Prochain rendez-vous'**
  String get homeNextAppt;

  /// No description provided for @homeMyAppts.
  ///
  /// In fr, this message translates to:
  /// **'Mes rendez-vous'**
  String get homeMyAppts;

  /// No description provided for @homeSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get homeSeeAll;

  /// No description provided for @homeQrTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon QR Code Patient'**
  String get homeQrTitle;

  /// No description provided for @homeQrSub.
  ///
  /// In fr, this message translates to:
  /// **'Présentez ce code à votre médecin.'**
  String get homeQrSub;

  /// No description provided for @homeNoApptsToday.
  ///
  /// In fr, this message translates to:
  /// **'Aucun RDV aujourd\'hui'**
  String get homeNoApptsToday;

  /// No description provided for @homePatientsToday.
  ///
  /// In fr, this message translates to:
  /// **'Patients aujourd\'hui'**
  String get homePatientsToday;

  /// No description provided for @actionPostpone.
  ///
  /// In fr, this message translates to:
  /// **'Reporter'**
  String get actionPostpone;

  /// No description provided for @actionCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get actionCancel;

  /// No description provided for @actionDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get actionDetails;

  /// No description provided for @actionBook.
  ///
  /// In fr, this message translates to:
  /// **'Prendre rendez-vous'**
  String get actionBook;

  /// No description provided for @homePrescriptions.
  ///
  /// In fr, this message translates to:
  /// **'Ordonnance'**
  String get homePrescriptions;

  /// No description provided for @homeStats.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get homeStats;

  /// No description provided for @adminManageUsers.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les utilisateurs'**
  String get adminManageUsers;

  /// No description provided for @adminActivityLogs.
  ///
  /// In fr, this message translates to:
  /// **'Journaux d\'activité'**
  String get adminActivityLogs;

  /// No description provided for @adminRbac.
  ///
  /// In fr, this message translates to:
  /// **'Rôles & Permissions (RBAC)'**
  String get adminRbac;

  /// No description provided for @adminAnalytics.
  ///
  /// In fr, this message translates to:
  /// **'Rapports & Analytics'**
  String get adminAnalytics;

  /// No description provided for @adminSystemSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres système'**
  String get adminSystemSettings;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @settingsMonCompte.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get settingsMonCompte;

  /// No description provided for @settingsSecurite.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get settingsSecurite;

  /// No description provided for @settingsPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get settingsPreferences;

  /// No description provided for @settingsLangue.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLangue;

  /// No description provided for @settingsChangerLangue.
  ///
  /// In fr, this message translates to:
  /// **'Changer la langue'**
  String get settingsChangerLangue;

  /// No description provided for @settingsEn.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get settingsEn;

  /// No description provided for @settingsFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsFr;

  /// No description provided for @settingsDeconnexion.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get settingsDeconnexion;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue lors du chargement.'**
  String get errorGeneric;

  /// No description provided for @errorConnection.
  ///
  /// In fr, this message translates to:
  /// **'Problème de connexion. Vérifiez votre internet.'**
  String get errorConnection;

  /// No description provided for @errorSession.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Veuillez vous reconnecter.'**
  String get errorSession;

  /// No description provided for @errorForbidden.
  ///
  /// In fr, this message translates to:
  /// **'Accès non autorisé.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ressource introuvable.'**
  String get errorNotFound;

  /// No description provided for @apptsUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get apptsUpcoming;

  /// No description provided for @apptsPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés'**
  String get apptsPast;

  /// No description provided for @apptsCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulés'**
  String get apptsCancelled;

  /// No description provided for @apptsNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous'**
  String get apptsNone;

  /// No description provided for @recordsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dossier médical'**
  String get recordsTitle;

  /// No description provided for @recordsEncrypted.
  ///
  /// In fr, this message translates to:
  /// **'Chiffré'**
  String get recordsEncrypted;

  /// No description provided for @recordsPersonalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations personnelles'**
  String get recordsPersonalInfo;

  /// No description provided for @recordsAntecedents.
  ///
  /// In fr, this message translates to:
  /// **'Antécédents'**
  String get recordsAntecedents;

  /// No description provided for @recordsAllergies.
  ///
  /// In fr, this message translates to:
  /// **'Allergies'**
  String get recordsAllergies;

  /// No description provided for @recordsPrescriptions.
  ///
  /// In fr, this message translates to:
  /// **'Ordonnances actives'**
  String get recordsPrescriptions;

  /// No description provided for @recordsConsultations.
  ///
  /// In fr, this message translates to:
  /// **'Historique consultations'**
  String get recordsConsultations;

  /// No description provided for @recordsLabResults.
  ///
  /// In fr, this message translates to:
  /// **'Résultats d\'analyses'**
  String get recordsLabResults;

  /// No description provided for @recordsAddNote.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une note médicale'**
  String get recordsAddNote;

  /// No description provided for @recordsMedicalNote.
  ///
  /// In fr, this message translates to:
  /// **'Note médicale'**
  String get recordsMedicalNote;

  /// No description provided for @recordsDiagnostic.
  ///
  /// In fr, this message translates to:
  /// **'Diagnostic'**
  String get recordsDiagnostic;

  /// No description provided for @recordsObservations.
  ///
  /// In fr, this message translates to:
  /// **'Observations'**
  String get recordsObservations;

  /// No description provided for @recordsSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get recordsSave;

  /// No description provided for @recordsId.
  ///
  /// In fr, this message translates to:
  /// **'ID dossier'**
  String get recordsId;

  /// No description provided for @recordsCreatedAt.
  ///
  /// In fr, this message translates to:
  /// **'Créé le'**
  String get recordsCreatedAt;

  /// No description provided for @recordsNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune information renseignée.'**
  String get recordsNone;

  /// No description provided for @recordsNoPrescr.
  ///
  /// In fr, this message translates to:
  /// **'Aucune ordonnance active.'**
  String get recordsNoPrescr;

  /// No description provided for @recordsUntil.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'au'**
  String get recordsUntil;

  /// No description provided for @recordsNoConsult.
  ///
  /// In fr, this message translates to:
  /// **'Aucune consultation enregistrée.'**
  String get recordsNoConsult;

  /// No description provided for @recordsNoLab.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat disponible.'**
  String get recordsNoLab;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhone;

  /// No description provided for @profileNotSet.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get profileNotSet;

  /// No description provided for @profileChangePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get profileChangePassword;

  /// No description provided for @profile2fa.
  ///
  /// In fr, this message translates to:
  /// **'Double authentification (2FA)'**
  String get profile2fa;

  /// No description provided for @profileActivityLog.
  ///
  /// In fr, this message translates to:
  /// **'Journal d\'activité'**
  String get profileActivityLog;

  /// No description provided for @profilePushNotif.
  ///
  /// In fr, this message translates to:
  /// **'Notifications push'**
  String get profilePushNotif;

  /// No description provided for @profileEmailReminders.
  ///
  /// In fr, this message translates to:
  /// **'Rappels par email'**
  String get profileEmailReminders;

  /// No description provided for @profileDanger.
  ///
  /// In fr, this message translates to:
  /// **'Danger'**
  String get profileDanger;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le compte ?'**
  String get profileDeleteConfirm;

  /// No description provided for @profileDeleteMessage.
  ///
  /// In fr, this message translates to:
  /// **'Toutes vos données seront supprimées définitivement.'**
  String get profileDeleteMessage;

  /// No description provided for @profileDeleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get profileDeleteAction;

  /// No description provided for @profileActionRequired.
  ///
  /// In fr, this message translates to:
  /// **'Action requise'**
  String get profileActionRequired;

  /// No description provided for @profileContactAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Contactez un administrateur pour supprimer votre compte.'**
  String get profileContactAdmin;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'🛡️ Administrateur'**
  String get roleAdmin;

  /// No description provided for @roleDoctor.
  ///
  /// In fr, this message translates to:
  /// **'👨‍⚕️ Médecin'**
  String get roleDoctor;

  /// No description provided for @rolePatient.
  ///
  /// In fr, this message translates to:
  /// **'🧑 Patient'**
  String get rolePatient;

  /// No description provided for @profileEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEdit;

  /// No description provided for @profileFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get profileFirstName;

  /// No description provided for @profileLastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get profileLastName;

  /// No description provided for @profileSpecialty.
  ///
  /// In fr, this message translates to:
  /// **'Spécialité'**
  String get profileSpecialty;

  /// No description provided for @profileCabinet.
  ///
  /// In fr, this message translates to:
  /// **'Cabinet / Clinique'**
  String get profileCabinet;

  /// No description provided for @profileUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour'**
  String get profileUpdated;

  /// No description provided for @bookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prendre rendez-vous'**
  String get bookingTitle;

  /// No description provided for @bookingStepSpecialty.
  ///
  /// In fr, this message translates to:
  /// **'Spécialité'**
  String get bookingStepSpecialty;

  /// No description provided for @bookingStepDoctor.
  ///
  /// In fr, this message translates to:
  /// **'Médecin'**
  String get bookingStepDoctor;

  /// No description provided for @bookingStepSlot.
  ///
  /// In fr, this message translates to:
  /// **'Créneau'**
  String get bookingStepSlot;

  /// No description provided for @bookingStepConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmation'**
  String get bookingStepConfirm;

  /// No description provided for @bookingLoadingSpecialties.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des spécialités...'**
  String get bookingLoadingSpecialties;

  /// No description provided for @bookingSelectSpecialty.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une spécialité'**
  String get bookingSelectSpecialty;

  /// No description provided for @bookingLoadingDoctors.
  ///
  /// In fr, this message translates to:
  /// **'Recherche des médecins...'**
  String get bookingLoadingDoctors;

  /// No description provided for @bookingSelectDoctorIn.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un médecin en {specialty}'**
  String bookingSelectDoctorIn(String specialty);

  /// No description provided for @bookingNoDoctors.
  ///
  /// In fr, this message translates to:
  /// **'Aucun médecin disponible pour cette spécialité.'**
  String get bookingNoDoctors;

  /// No description provided for @bookingSelectSlot.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un créneau'**
  String get bookingSelectSlot;

  /// No description provided for @bookingAvailableSlots.
  ///
  /// In fr, this message translates to:
  /// **'Créneaux disponibles'**
  String get bookingAvailableSlots;

  /// No description provided for @bookingLoadingSlots.
  ///
  /// In fr, this message translates to:
  /// **'Récupération des créneaux...'**
  String get bookingLoadingSlots;

  /// No description provided for @bookingNoSlots.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau disponible pour cette date.'**
  String get bookingNoSlots;

  /// No description provided for @bookingConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le rendez-vous'**
  String get bookingConfirmTitle;

  /// No description provided for @bookingLabelDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get bookingLabelDate;

  /// No description provided for @bookingLabelTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get bookingLabelTime;

  /// No description provided for @bookingLabelDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get bookingLabelDuration;

  /// No description provided for @bookingDurationValue.
  ///
  /// In fr, this message translates to:
  /// **'30 minutes'**
  String get bookingDurationValue;

  /// No description provided for @bookingLabelMotif.
  ///
  /// In fr, this message translates to:
  /// **'Motif (optionnel)'**
  String get bookingLabelMotif;

  /// No description provided for @bookingHintMotif.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Douleur thoracique, bilan annuel...'**
  String get bookingHintMotif;

  /// No description provided for @bookingActionNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant →'**
  String get bookingActionNext;

  /// No description provided for @bookingActionConfirm.
  ///
  /// In fr, this message translates to:
  /// **'✓ Confirmer le rendez-vous'**
  String get bookingActionConfirm;

  /// No description provided for @bookingSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous réservé avec succès !'**
  String get bookingSuccess;

  /// No description provided for @bookingError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de réserver ce créneau.'**
  String get bookingError;

  /// No description provided for @roleNurse.
  ///
  /// In fr, this message translates to:
  /// **'🩺 Infirmier(ère)'**
  String get roleNurse;

  /// No description provided for @homeManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion'**
  String get homeManagement;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter ?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment fermer votre session ?'**
  String get logoutConfirmMessage;

  /// No description provided for @bookingConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la réservation'**
  String get bookingConfirmAction;

  /// No description provided for @bookingConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous confirmer ce rendez-vous ?'**
  String get bookingConfirmMessage;

  /// No description provided for @saveConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications ?'**
  String get saveConfirmTitle;

  /// No description provided for @saveConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos informations seront mises à jour.'**
  String get saveConfirmMessage;

  /// No description provided for @prescriptionConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Émettre l\'ordonnance ?'**
  String get prescriptionConfirmTitle;

  /// No description provided for @prescriptionConfirmMessage.
  ///
  /// In fr, this message translates to:
  /// **'L\'ordonnance sera envoyée au patient.'**
  String get prescriptionConfirmMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
