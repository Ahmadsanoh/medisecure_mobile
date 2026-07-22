import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'services/logger_service.dart';

import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'models/user_model.dart';
import 'screens/auth/legal_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/appointments/appointments_screen.dart';
import 'screens/appointments/booking_screen.dart';
import 'screens/appointments/appointment_detail_screen.dart';
import 'screens/records/records_screen.dart';
import 'screens/records/prescription_screen.dart';
import 'screens/records/vitals_form_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/user_management_screen.dart';
import 'screens/admin/logs_screen.dart';
import 'screens/admin/rbac_screen.dart';
import 'screens/admin/analytics_screen.dart';
import 'screens/admin/system_settings_screen.dart';
import 'screens/profile/change_password_screen.dart';
import 'screens/profile/my_activity_log_screen.dart';
import 'screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final user = ref.read(currentUserProvider);
      final isLoggedIn = user != null;
      final loc = state.matchedLocation;
      final isAuthRoute = loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/forgot') ||
          loc.startsWith('/splash') ||
          loc.startsWith('/onboarding');

      if (!isLoggedIn && !isAuthRoute) {
        log.v('🛡️ REDIRECT: Accès non authentifié => /login');
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        log.v('🛡️ REDIRECT: Déjà authentifié => /home');
        return '/home';
      }
      if (isLoggedIn && loc.startsWith('/admin') && user.role != 'admin') {
        log.w(
            '🛡️ SECURITY: Tentative d\'accès Admin par ${user.fullName} (${user.role}) => Accès refusé');
        return '/home';
      }
      log.v('🚀 NAVIGTING TO: $loc');
      return null;
    },
    routes: [
      // ── Entry points ─────────────────────────────────────────────────────
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(
        path: '/terms',
        builder: (_, __) => const LegalScreen(
          title: 'Conditions d\'utilisation',
          content:
              '1. Acceptation des conditions\nEn accédant à MediSecure, vous acceptez d\'être lié par les présentes conditions d\'utilisation.\n\n2. Services fournis\nMediSecure est une plateforme de gestion médicale permettant la prise de rendez-vous et le suivi du dossier médical.',
        ),
      ),
      GoRoute(
        path: '/privacy',
        builder: (_, __) => const LegalScreen(
          title: 'Politique de confidentialité',
          content:
              '1. Données collectées\nNous collectons des données relatives à votre identité et à votre santé pour assurer le service MediSecure.\n\n2. Utilisation des données\nVos données sont exclusivement utilisées pour la gestion de vos soins et ne sont jamais revendues.',
        ),
      ),

      // ── Auth routes ──────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(
          path: '/forgot', builder: (_, __) => const ForgotPasswordScreen()),

      // ── Shell (tab bar) ──────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/appointments',
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: AppointmentsScreen()),
            routes: [
              GoRoute(path: 'book', builder: (_, __) => const BookingScreen()),
              GoRoute(
                path: ':id',
                builder: (_, state) => AppointmentDetailScreen(
                    id: int.parse(state.pathParameters['id']!)),
              ),
            ],
          ),
          GoRoute(
            path: '/records',
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: RecordsScreen()),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => RecordsScreen(
                    patientId: int.tryParse(state.pathParameters['id'] ?? '')),
                routes: [
                  GoRoute(
                    path: 'vitals',
                    builder: (_, state) => VitalsFormScreen(
                      patientId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'prescriptions',
                builder: (_, state) => PrescriptionScreen(
                  patientId: int.tryParse(
                      state.uri.queryParameters['patientId'] ?? ''),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: NotificationsScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: ProfileScreen()),
            routes: [
              GoRoute(
                  path: 'edit', builder: (_, __) => const EditProfileScreen()),
              GoRoute(
                  path: 'change-password',
                  builder: (_, __) => const ChangePasswordScreen()),
              GoRoute(
                  path: 'activity-log',
                  builder: (_, __) => const MyActivityLogScreen()),
            ],
          ),
        ],
      ),

      // ── Admin routes (no tab shell) ──────────────────────────────────────
      GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),
      GoRoute(
          path: '/admin/users',
          builder: (_, __) => const UserManagementScreen()),
      GoRoute(path: '/admin/logs', builder: (_, __) => const LogsScreen()),
      GoRoute(path: '/admin/rbac', builder: (_, __) => const RbacScreen()),
      GoRoute(
          path: '/admin/analytics',
          builder: (_, __) => const AnalyticsScreen()),
      GoRoute(
          path: '/admin/settings',
          builder: (_, __) => const SystemSettingsScreen()),
    ],
  );
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen<UserModel?>(
      currentUserProvider,
      (_, __) => notifyListeners(),
    );
  }
}
