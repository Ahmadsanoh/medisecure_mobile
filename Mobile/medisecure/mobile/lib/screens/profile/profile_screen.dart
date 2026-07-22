import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/auth_service.dart';
import '../../services/locale_service.dart';
import '../../services/settings_service.dart';
import '../../widgets/ms_dialog.dart';
import '../../widgets/ms_shimmer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: ProfileSkeleton()),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (user) {
        if (user == null) return const SizedBox();
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: const Color(0xFF1A56DB),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A56DB), Color(0xFF0A2D7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white24,
                            child: Text(
                              '${user.prenom[0]}${user.nom[0]}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(user.fullName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(_roleLabel(context, user.role),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ]),
                  ),
                ),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => context.push('/profile/edit')),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  // Account info
                  _SettingsSection(
                      title: AppLocalizations.of(context)!.settingsMonCompte,
                      items: [
                        _SettingsTile(
                            icon: Icons.person_outline,
                            iconBg: const Color(0xFFDBEAFE),
                            label: AppLocalizations.of(context)!
                                .recordsPersonalInfo,
                            subtitle: user.email,
                            onTap: () => context.push('/profile/edit')),
                        _SettingsTile(
                            icon: Icons.phone_outlined,
                            iconBg: const Color(0xFFDCFCE7),
                            label: AppLocalizations.of(context)!.profilePhone,
                            subtitle: user.telephone ??
                                AppLocalizations.of(context)!.profileNotSet,
                            onTap: () => context.push('/profile/edit')),
                      ]),
                  const SizedBox(height: 12),

                  // Security
                  _SettingsSection(
                      title: AppLocalizations.of(context)!.settingsSecurite,
                      items: [
                        _SettingsTile(
                            icon: Icons.lock_outline,
                            iconBg: const Color(0xFFEFF6FF),
                            label: AppLocalizations.of(context)!
                                .profileChangePassword,
                            onTap: () => context.push('/profile/change-password')),
                        _SettingsToggleTile(
                            icon: Icons.security,
                            iconBg: const Color(0xFFDCFCE7),
                            label: AppLocalizations.of(context)!.profile2fa,
                            initialValue: true),
                        _SettingsTile(
                            icon: Icons.history,
                            iconBg: const Color(0xFFF3E8FF),
                            label: AppLocalizations.of(context)!
                                .profileActivityLog,
                            onTap: () => context.push('/profile/activity-log')),
                      ]),
                  const SizedBox(height: 12),

                  // Preferences
                  _SettingsSection(
                      title: AppLocalizations.of(context)!.settingsPreferences,
                      items: [
                        _PersistedToggleTile(
                            icon: Icons.notifications_outlined,
                            iconBg: const Color(0xFFFEF3C7),
                            label:
                                AppLocalizations.of(context)!.profilePushNotif,
                            valueAsync: ref.watch(pushNotificationsProvider),
                            onChanged: (v) => ref
                                .read(pushNotificationsProvider.notifier)
                                .set(v)),
                        _PersistedToggleTile(
                            icon: Icons.email_outlined,
                            iconBg: const Color(0xFFDBEAFE),
                            label: AppLocalizations.of(context)!
                                .profileEmailReminders,
                            valueAsync: ref.watch(emailRemindersProvider),
                            onChanged: (v) => ref
                                .read(emailRemindersProvider.notifier)
                                .set(v)),
                        _SettingsTile(
                            icon: Icons.language,
                            iconBg: const Color(0xFFF1F5F9),
                            label: AppLocalizations.of(context)!.settingsLangue,
                            subtitle:
                                Localizations.localeOf(context).languageCode ==
                                        'fr'
                                    ? AppLocalizations.of(context)!.settingsFr
                                    : AppLocalizations.of(context)!.settingsEn,
                            onTap: () => _showLanguagePicker(context, ref)),
                      ]),
                  const SizedBox(height: 12),

                  // Admin-specific
                  if (user.role == 'admin') ...[
                    _SettingsSection(
                        title: AppLocalizations.of(context)!.homeAlerts,
                        items: [
                          _SettingsTile(
                              icon: Icons.people_outline,
                              iconBg: const Color(0xFFDBEAFE),
                              label: AppLocalizations.of(context)!
                                  .adminManageUsers,
                              onTap: () => context.push('/admin/users')),
                          _SettingsTile(
                              icon: Icons.assignment_outlined,
                              iconBg: const Color(0xFFFEF3C7),
                              label: AppLocalizations.of(context)!
                                  .adminActivityLogs,
                              onTap: () => context.push('/admin/logs')),
                          _SettingsTile(
                              icon: Icons.shield_outlined,
                              iconBg: const Color(0xFFDCFCE7),
                              label: AppLocalizations.of(context)!.adminRbac,
                              onTap: () => context.push('/admin/rbac')),
                        ]),
                    const SizedBox(height: 12),
                  ],

                  // Danger zone
                  _SettingsSection(
                      title: AppLocalizations.of(context)!.profileDanger,
                      items: [
                        _SettingsTile(
                            icon: Icons.delete_outline,
                            iconBg: const Color(0xFFFEE2E2),
                            label: AppLocalizations.of(context)!
                                .profileDeleteAccount,
                            labelColor: const Color(0xFFDC2626),
                            onTap: () => _confirmDelete(context, ref)),
                      ]),
                  const SizedBox(height: 20),

                  OutlinedButton.icon(
                    onPressed: () => _logout(context, ref),
                    icon: const Icon(Icons.logout),
                    label:
                        Text(AppLocalizations.of(context)!.settingsDeconnexion),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ])),
              ),
            ],
          ),
        );
      },
    );
  }

  String _roleLabel(BuildContext context, String r) => switch (r) {
        'admin' => AppLocalizations.of(context)!.roleAdmin,
        'doctor' => AppLocalizations.of(context)!.roleDoctor,
        'nurse' => AppLocalizations.of(context)!.roleNurse,
        _ => AppLocalizations.of(context)!.rolePatient,
      };

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showConfirmDialog(
      context,
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmMessage,
      confirmLabel: l10n.settingsDeconnexion,
    );
    if (confirm && context.mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (context.mounted) context.go('/login');
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showConfirmDialog(
      context,
      title: AppLocalizations.of(context)!.profileDeleteConfirm,
      message: AppLocalizations.of(context)!.profileDeleteMessage,
      confirmLabel: AppLocalizations.of(context)!.profileDeleteAction,
    );
    if (confirm && context.mounted) {
      showInfoDialog(context,
          title: AppLocalizations.of(context)!.profileActionRequired,
          message: AppLocalizations.of(context)!.profileContactAdmin);
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.settingsChangerLangue,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            ListTile(
              title: Text(AppLocalizations.of(context)!.settingsFr),
              trailing: Localizations.localeOf(context).languageCode == 'fr'
                  ? const Icon(Icons.check, color: Color(0xFF1A56DB))
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.settingsEn),
              trailing: Localizations.localeOf(context).languageCode == 'en'
                  ? const Icon(Icons.check, color: Color(0xFF1A56DB))
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile widgets ───────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SettingsSection({required this.title, required this.items});

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
          Card(
            child: Column(
                children: items
                    .map((item) => Column(children: [
                          item,
                          if (item != items.last)
                            const Divider(
                                height: 1,
                                indent: 56,
                                color: Color(0xFFF1F5F9)),
                        ]))
                    .toList()),
          ),
        ],
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String? subtitle;
  final Color? labelColor;
  final VoidCallback onTap;
  const _SettingsTile(
      {required this.icon,
      required this.iconBg,
      required this.label,
      this.subtitle,
      this.labelColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: onTap,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: const Color(0xFF1A56DB)),
        ),
        title: Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: labelColor ?? const Color(0xFF1E293B))),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)))
            : null,
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
      );
}

class _PersistedToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final AsyncValue<bool> valueAsync;
  final ValueChanged<bool> onChanged;
  const _PersistedToggleTile({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.valueAsync,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final value = valueAsync.value ?? true;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration:
            BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: const Color(0xFF1A56DB)),
      ),
      title: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: valueAsync.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2))
          : Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFF1A56DB),
            ),
    );
  }
}

class _SettingsToggleTile extends StatefulWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final bool initialValue;
  const _SettingsToggleTile(
      {required this.icon,
      required this.iconBg,
      required this.label,
      required this.initialValue});
  @override
  State<_SettingsToggleTile> createState() => _ToggleState();
}

class _ToggleState extends State<_SettingsToggleTile> {
  late bool _val;
  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: widget.iconBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(widget.icon, size: 18, color: const Color(0xFF1A56DB)),
        ),
        title: Text(widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        trailing: Switch(
          value: _val,
          onChanged: (v) => setState(() => _val = v),
          activeThumbColor: const Color(0xFF1A56DB),
        ),
      );
}
