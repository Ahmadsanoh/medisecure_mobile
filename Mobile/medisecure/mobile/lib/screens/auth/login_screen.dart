import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/auth_service.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_text_field.dart';
import '../../widgets/ms_dialog.dart';
import '../../utils/validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).login(
            _emailCtrl.text.trim(),
            _passCtrl.text,
          );
      TextInput.finishAutofillContext();
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      if (msg.contains('401') || msg.contains('incorrect')) {
        await showInfoDialog(context,
            title: 'Identifiants incorrects',
            message: 'Email ou mot de passe invalide.');
      } else if (msg.contains('inactif') || msg.contains('vérifié')) {
        await showInfoDialog(context,
            title: 'Compte non activé',
            message:
                'Veuillez vérifier votre email pour activer votre compte.');
      } else if (msg.contains('SocketException') ||
          msg.contains('connection')) {
        await showInfoDialog(context,
            title: 'Connexion impossible',
            message: 'Vérifiez votre connexion réseau et réessayez.');
      } else {
        showErrorSnackBar(context, e);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A56DB), Color(0xFF0A2D7A)],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(28.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  // Logo
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(Icons.local_hospital,
                        color: Colors.white, size: 40.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text('MediSecure',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 6.h),
                  Text('Votre santé, sécurisée et connectée',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13.sp)),
                  SizedBox(height: 36.h),

                  // Card
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.connexion,
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 20.h),
                          MsTextField(
                            controller: _emailCtrl,
                            label: AppLocalizations.of(context)!.loginEmail,
                            hint: 'vous@exemple.fr',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: Validators.email,
                            autofillHints: const [AutofillHints.email],
                          ),
                          SizedBox(height: 14.h),
                          MsTextField(
                            controller: _passCtrl,
                            label: AppLocalizations.of(context)!.loginPassword,
                            hint: '••••••••',
                            obscureText: true,
                            prefixIcon: Icons.lock_outline,
                            validator: Validators.required,
                            autofillHints: const [AutofillHints.password],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push('/forgot'),
                              child: Text(
                                  AppLocalizations.of(context)!
                                      .loginForgotPassword,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp)),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          MsButton(
                              label: AppLocalizations.of(context)!.loginSubmit,
                              loading: _loading,
                              padding: EdgeInsets
                                  .zero, // Padding already handled by the card
                              onPressed: _submit),
                          SizedBox(height: 16.h),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.loginNoAccount,
                                  style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 13.sp)),
                              GestureDetector(
                                onTap: () => context.push('/register'),
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .loginCreateAccount,
                                    style: TextStyle(
                                        color: const Color(0xFF1A56DB),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.white54, size: 14.sp),
                      SizedBox(width: 6.w),
                      Text('Connexion chiffrée SSL/TLS — JWT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12.sp)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
