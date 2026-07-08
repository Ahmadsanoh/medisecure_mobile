import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medisecure/l10n/app_localizations.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  List<_TabData> _getTabs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _TabData(icon: Icons.home_rounded, label: l10n.navHome, path: '/home'),
      _TabData(
          icon: Icons.calendar_month,
          label: l10n.navAppointments,
          path: '/appointments'),
      _TabData(
          icon: Icons.folder_open_rounded,
          label: l10n.navRecords,
          path: '/records'),
      _TabData(
          icon: Icons.notifications,
          label: l10n.navNotifications,
          path: '/notifications'),
      _TabData(
          icon: Icons.person_rounded, label: l10n.navProfile, path: '/profile'),
    ];
  }

  int _currentIndex(BuildContext context, List<_TabData> tabs) {
    final loc = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < tabs.length; i++) {
      if (loc.startsWith(tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = _getTabs(context);
    final idx = _currentIndex(context, tabs);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(tabs[i].path),
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: const Color(0xFFDBEAFE),
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;
  final String path;
  _TabData({required this.icon, required this.label, required this.path});
}
