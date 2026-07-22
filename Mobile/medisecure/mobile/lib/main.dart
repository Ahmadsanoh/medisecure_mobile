import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medisecure/l10n/app_localizations.dart';
import 'router.dart';
import 'services/auth_service.dart';
import 'services/appointment_service.dart';
import 'services/notification_service.dart';
import 'services/connectivity_service.dart';
import 'services/logger_service.dart';
import 'services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('fr', null);
  await initializeDateFormatting('en', null);

  // Global Error Handling for full observability
  PlatformDispatcher.instance.onError = (error, stack) {
    log.e('CRASH NON-GÉRÉ', error, stack);
    return true;
  };

  runApp(const ProviderScope(child: MediSecureApp()));
}

class MediSecureApp extends ConsumerStatefulWidget {
  const MediSecureApp({super.key});

  @override
  ConsumerState<MediSecureApp> createState() => _MediSecureAppState();
}

class _MediSecureAppState extends ConsumerState<MediSecureApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log.v('📱 App Lifecycle State: ${state.name}');
    if (state == AppLifecycleState.resumed) {
      // Re-fetch essential data when returning to the app
      ref.invalidate(currentUserProvider);
      ref.invalidate(appointmentsProvider);
      ref.invalidate(unreadCountProvider);
      log.i('Données rafraîchies après retour au premier plan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final isOffline = ref.watch(isOfflineProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14 standard
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'MediSecure',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
          routerConfig: router,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                if (isOffline)
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: Material(
                      child: Container(
                        color: Colors.red.shade600,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off,
                                color: Colors.white, size: 16.sp),
                            SizedBox(width: 8.w),
                            Text(
                              "Mode hors connexion",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme() {
    const primaryBlue = Color(0xFF1A56DB);
    const secondaryTeal = Color(0xFF0D9488);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryTeal,
        surface: Colors.white,
        background: const Color(0xFFF8FAFC),
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          minimumSize: Size(double.infinity, 50.h),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: Color(0xFFE5E9EF)),
        ),
      ),
    );
  }
}
