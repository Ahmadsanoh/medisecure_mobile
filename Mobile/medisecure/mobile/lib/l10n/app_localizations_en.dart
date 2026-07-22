// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MediSecure';

  @override
  String get connexion => 'Login';

  @override
  String get loginEmail => 'Email Address';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get loginSubmit => 'Login';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginCreateAccount => 'Create an account';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Read all';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get notificationsEmptySub =>
      'You will be informed as soon as there is something new.';

  @override
  String get navHome => 'Home';

  @override
  String get navAppointments => 'Appts';

  @override
  String get navRecords => 'Records';

  @override
  String get navNotifications => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeWelcome => 'Hello';

  @override
  String get homeWelcomePatient => 'Hello 👋';

  @override
  String get homeUpcomingAppointments => 'Upcoming appointments';

  @override
  String get homeNoAppointments => 'No upcoming appointments';

  @override
  String get homeTotalAppts => 'Total Appts';

  @override
  String get homeConfirmed => 'Confirmed';

  @override
  String get homePending => 'Pending';

  @override
  String get homeAlerts => 'Alerts';

  @override
  String get homeQuickActions => 'Quick Actions';

  @override
  String get homeBookAppt => 'Book Appt';

  @override
  String get homeMyRecords => 'My Records';

  @override
  String get homeQrCode => 'QR Code';

  @override
  String get homeHistory => 'History';

  @override
  String get homeNextAppt => 'Next Appointment';

  @override
  String get homeMyAppts => 'My Appointments';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeQrTitle => 'My Patient QR Code';

  @override
  String get homeQrSub => 'Present this code to your doctor.';

  @override
  String get homeNoApptsToday => 'No appointments today';

  @override
  String get homePatientsToday => 'Patients Today';

  @override
  String get actionPostpone => 'Postpone';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDetails => 'Details';

  @override
  String get actionBook => 'Book appointment';

  @override
  String get homePrescriptions => 'Prescription';

  @override
  String get homeStats => 'Stats';

  @override
  String get adminManageUsers => 'Manage Users';

  @override
  String get adminActivityLogs => 'Activity Logs';

  @override
  String get adminRbac => 'Roles & Permissions (RBAC)';

  @override
  String get adminAnalytics => 'Reports & Analytics';

  @override
  String get adminSystemSettings => 'System Settings';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Error';

  @override
  String get settingsMonCompte => 'My Account';

  @override
  String get settingsSecurite => 'Security';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsLangue => 'Language';

  @override
  String get settingsChangerLangue => 'Change Language';

  @override
  String get settingsEn => 'English';

  @override
  String get settingsFr => 'French';

  @override
  String get settingsDeconnexion => 'Logout';

  @override
  String get errorGeneric => 'An error occurred while loading.';

  @override
  String get errorConnection => 'Connection problem. Check your internet.';

  @override
  String get errorSession => 'Your session has expired. Please log in again.';

  @override
  String get errorForbidden => 'Access denied.';

  @override
  String get errorNotFound => 'Resource not found.';

  @override
  String get apptsUpcoming => 'Upcoming';

  @override
  String get apptsPast => 'Past';

  @override
  String get apptsCancelled => 'Cancelled';

  @override
  String get apptsNone => 'No appointments';

  @override
  String get recordsTitle => 'Medical Record';

  @override
  String get recordsEncrypted => 'Encrypted';

  @override
  String get recordsPersonalInfo => 'Personal Information';

  @override
  String get recordsAntecedents => 'History';

  @override
  String get recordsAllergies => 'Allergies';

  @override
  String get recordsPrescriptions => 'Active Prescriptions';

  @override
  String get recordsConsultations => 'Consultation History';

  @override
  String get recordsLabResults => 'Lab Results';

  @override
  String get recordsAddNote => 'Add medical note';

  @override
  String get recordsMedicalNote => 'Medical Note';

  @override
  String get recordsDiagnostic => 'Diagnosis';

  @override
  String get recordsObservations => 'Observations';

  @override
  String get recordsSave => 'Save';

  @override
  String get recordsId => 'Record ID';

  @override
  String get recordsCreatedAt => 'Created on';

  @override
  String get recordsNone => 'No information provided.';

  @override
  String get recordsNoPrescr => 'No active prescriptions.';

  @override
  String get recordsUntil => 'Until';

  @override
  String get recordsNoConsult => 'No consultations recorded.';

  @override
  String get recordsNoLab => 'No results available.';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileNotSet => 'Not set';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profile2fa => 'Two-factor authentication (2FA)';

  @override
  String get profileActivityLog => 'Activity log';

  @override
  String get profilePushNotif => 'Push notifications';

  @override
  String get profileEmailReminders => 'Email reminders';

  @override
  String get profileDanger => 'Danger';

  @override
  String get profileDeleteAccount => 'Delete my account';

  @override
  String get profileDeleteConfirm => 'Delete account?';

  @override
  String get profileDeleteMessage =>
      'All your data will be permanently deleted.';

  @override
  String get profileDeleteAction => 'Delete';

  @override
  String get profileActionRequired => 'Action required';

  @override
  String get profileContactAdmin =>
      'Contact an administrator to delete your account.';

  @override
  String get roleAdmin => '🛡️ Administrator';

  @override
  String get roleDoctor => '👨‍⚕️ Doctor';

  @override
  String get rolePatient => '🧑 Patient';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileFirstName => 'First Name';

  @override
  String get profileLastName => 'Last Name';

  @override
  String get profileSpecialty => 'Specialty';

  @override
  String get profileCabinet => 'Clinic / Office';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get bookingTitle => 'Book Appointment';

  @override
  String get bookingStepSpecialty => 'Specialty';

  @override
  String get bookingStepDoctor => 'Doctor';

  @override
  String get bookingStepSlot => 'Slot';

  @override
  String get bookingStepConfirm => 'Confirmation';

  @override
  String get bookingLoadingSpecialties => 'Loading specialties...';

  @override
  String get bookingSelectSpecialty => 'Choose a specialty';

  @override
  String get bookingLoadingDoctors => 'Finding doctors...';

  @override
  String bookingSelectDoctorIn(String specialty) {
    return 'Choose a doctor in $specialty';
  }

  @override
  String get bookingNoDoctors => 'No doctors available for this specialty.';

  @override
  String get bookingSelectSlot => 'Choose a time slot';

  @override
  String get bookingAvailableSlots => 'Available slots';

  @override
  String get bookingLoadingSlots => 'Retrieving slots...';

  @override
  String get bookingNoSlots => 'No slots available for this date.';

  @override
  String get bookingConfirmTitle => 'Confirm Appointment';

  @override
  String get bookingLabelDate => 'Date';

  @override
  String get bookingLabelTime => 'Time';

  @override
  String get bookingLabelDuration => 'Duration';

  @override
  String get bookingDurationValue => '30 minutes';

  @override
  String get bookingLabelMotif => 'Reason (optional)';

  @override
  String get bookingHintMotif => 'Ex: Chest pain, annual check-up...';

  @override
  String get bookingActionNext => 'Next →';

  @override
  String get bookingActionConfirm => '✓ Confirm Appointment';

  @override
  String get bookingSuccess => 'Appointment successfully booked!';

  @override
  String get bookingError => 'Unable to book this slot.';

  @override
  String get roleNurse => '🩺 Nurse';

  @override
  String get homeManagement => 'Management';

  @override
  String get logoutConfirmTitle => 'Logout?';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get bookingConfirmAction => 'Confirm Booking';

  @override
  String get bookingConfirmMessage =>
      'Do you want to confirm this appointment?';

  @override
  String get saveConfirmTitle => 'Save changes?';

  @override
  String get saveConfirmMessage => 'Your information will be updated.';

  @override
  String get prescriptionConfirmTitle => 'Issue prescription?';

  @override
  String get prescriptionConfirmMessage =>
      'The prescription will be sent to the patient.';
}
