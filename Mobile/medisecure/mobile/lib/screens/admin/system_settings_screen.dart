import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/admin_service.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/settings_service.dart';
import '../../widgets/ms_dialog.dart';

class SystemSettingsScreen extends ConsumerWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final push = ref.watch(pushNotificationsProvider);
    final email = ref.watch(emailRemindersProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Paramètres système')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'État de la connexion', children: [
            _InfoTile(
              icon: isOffline ? Icons.cloud_off : Icons.cloud_done,
              iconColor:
                  isOffline ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
              label: isOffline ? 'Hors ligne' : 'Connecté',
              value: isOffline
                  ? 'Aucune connexion réseau détectée'
                  : 'L\'app communique normalement avec le serveur',
            ),
            _InfoTile(
              icon: Icons.dns_outlined,
              iconColor: const Color(0xFF1A56DB),
              label: 'Serveur API',
              value: ApiClient.baseUrl,
            ),
          ]),
          const SizedBox(height: 16),
          _Section(title: 'Compte', children: [
            _InfoTile(
              icon: Icons.badge_outlined,
              iconColor: const Color(0xFF7C3AED),
              label: 'Connecté en tant que',
              value: '${user?.fullName ?? '—'} (${user?.email ?? '—'})',
            ),
          ]),
          const SizedBox(height: 16),
          _Section(title: 'Notifications (appareil)', children: [
            push.when(
              data: (v) => SwitchListTile(
                value: v,
                onChanged: (nv) =>
                    ref.read(pushNotificationsProvider.notifier).set(nv),
                title: const Text('Notifications push',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Rendez-vous, rappels, messages',
                    style: TextStyle(fontSize: 12)),
                activeThumbColor: const Color(0xFF1A56DB),
              ),
              loading: () => const ListTile(
                  title: Text('Notifications push'),
                  trailing: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))),
              error: (_, __) => const ListTile(title: Text('Indisponible')),
            ),
            email.when(
              data: (v) => SwitchListTile(
                value: v,
                onChanged: (nv) =>
                    ref.read(emailRemindersProvider.notifier).set(nv),
                title: const Text('Rappels par email',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: const Text('Confirmations et rappels de rendez-vous',
                    style: TextStyle(fontSize: 12)),
                activeThumbColor: const Color(0xFF1A56DB),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ]),
          const SizedBox(height: 16),
          _Section(title: 'Maintenance', children: [
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF1A56DB)),
              title: const Text('Rafraîchir les données',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: const Text(
                  'Force le rechargement de toutes les données en cache',
                  style: TextStyle(fontSize: 12)),
              onTap: () {
                ref.invalidate(adminStatsProvider);
                ref.invalidate(allUsersProvider);
                ref.invalidate(logsProvider);
                ref.invalidate(myActivityLogProvider);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('✅ Données rafraîchies')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              title: const Text('Se déconnecter de tous les appareils',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626))),
              subtitle: const Text(
                  'Invalide votre session locale et vous ramène à l\'écran de connexion',
                  style: TextStyle(fontSize: 12)),
              onTap: () async {
                final confirm = await showConfirmDialog(context,
                    title: 'Se déconnecter ?',
                    message:
                        'Vous devrez vous reconnecter avec votre email et mot de passe.',
                    confirmLabel: 'Se déconnecter');
                if (confirm && context.mounted) {
                  await ref.read(authStateProvider.notifier).logout();
                }
              },
            ),
          ]),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(title.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                    letterSpacing: .6)),
          ),
          Card(child: Column(children: children)),
        ],
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon,
      required this.iconColor,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 12)),
      );
}
