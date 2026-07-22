import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPushNotifications = 'settings_push_notifications';
const _kEmailReminders = 'settings_email_reminders';

/// Préférences utilisateur persistées localement sur l'appareil (contrairement
/// aux anciens interrupteurs de profil, qui perdaient leur valeur à chaque
/// redémarrage de l'app car ils n'étaient jamais sauvegardés nulle part).
class SettingsService {
  Future<bool> getPushNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kPushNotifications) ?? true;
  }

  Future<void> setPushNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPushNotifications, value);
  }

  Future<bool> getEmailReminders() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kEmailReminders) ?? true;
  }

  Future<void> setEmailReminders(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kEmailReminders, value);
  }
}

final settingsServiceProvider = Provider((_) => SettingsService());

class PushNotificationsNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(settingsServiceProvider).getPushNotifications();

  Future<void> set(bool value) async {
    state = AsyncData(value);
    await ref.read(settingsServiceProvider).setPushNotifications(value);
  }
}

class EmailRemindersNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(settingsServiceProvider).getEmailReminders();

  Future<void> set(bool value) async {
    state = AsyncData(value);
    await ref.read(settingsServiceProvider).setEmailReminders(value);
  }
}

final pushNotificationsProvider =
    AsyncNotifierProvider<PushNotificationsNotifier, bool>(
        PushNotificationsNotifier.new);

final emailRemindersProvider =
    AsyncNotifierProvider<EmailRemindersNotifier, bool>(
        EmailRemindersNotifier.new);
