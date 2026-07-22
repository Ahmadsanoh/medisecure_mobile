import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_service.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_text_field.dart';
import '../../widgets/ms_dialog.dart';
import '../../utils/validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'patient';
  bool _loading = false;
  bool _acceptTerms = false;

  static const _roles = [
    ('patient', '🧑', 'Patient'),
    ('doctor', '👨‍⚕️', 'Médecin'),
    ('nurse', '👩‍⚕️', 'Infirmier·e'),
  ];

  @override
  void dispose() {
    for (final c in [_nomCtrl, _prenomCtrl, _emailCtrl, _telCtrl, _passCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez accepter les conditions d\'utilisation')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).register({
        'nom': _nomCtrl.text.trim(),
        'prenom': _prenomCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'telephone': _telCtrl.text.trim(),
        'password': _passCtrl.text,
        'role': _role,
      });
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      if (msg.contains('déjà utilisé') || msg.contains('409')) {
        await showInfoDialog(context,
            title: 'Email déjà utilisé',
            message: 'Un compte existe déjà avec cet email.');
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
      appBar: AppBar(title: const Text('Créer un compte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rôle',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                      letterSpacing: .5)),
              const SizedBox(height: 10),
              Row(
                  children: _roles
                      .map((r) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(() => _role = r.$1),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _role == r.$1
                                          ? const Color(0xFF1A56DB)
                                          : const Color(0xFFE2E8F0),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: _role == r.$1
                                        ? const Color(0xFFEFF6FF)
                                        : Colors.white,
                                  ),
                                  child: Column(children: [
                                    Text(r.$2,
                                        style: const TextStyle(fontSize: 22)),
                                    const SizedBox(height: 4),
                                    Text(r.$3,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: _role == r.$1
                                              ? const Color(0xFF1A56DB)
                                              : const Color(0xFF64748B),
                                        )),
                                  ]),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
              const SizedBox(height: 20),
              MsTextField(
                  controller: _prenomCtrl,
                  label: 'Prénom',
                  hint: 'Jean',
                  prefixIcon: Icons.person_outline,
                  validator: Validators.required),
              const SizedBox(height: 14),
              MsTextField(
                  controller: _nomCtrl,
                  label: 'Nom',
                  hint: 'Dupont',
                  prefixIcon: Icons.person_outline,
                  validator: Validators.required),
              const SizedBox(height: 14),
              MsTextField(
                  controller: _emailCtrl,
                  label: 'Email',
                  hint: 'jean@exemple.fr',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: Validators.email),
              const SizedBox(height: 14),
              MsTextField(
                  controller: _telCtrl,
                  label: 'Téléphone',
                  hint: '+33 6 00 00 00 00',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined),
              const SizedBox(height: 14),
              MsTextField(
                  controller: _passCtrl,
                  label: 'Mot de passe',
                  hint: 'Min. 8 caractères',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  validator: Validators.password),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: (val) =>
                          setState(() => _acceptTerms = val ?? false),
                      activeColor: const Color(0xFF1A56DB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Color(0xFF64748B), fontSize: 13),
                          children: [
                            const TextSpan(text: 'J\'accepte les '),
                            TextSpan(
                              text: 'conditions d\'utilisation',
                              style: const TextStyle(
                                  color: Color(0xFF1A56DB),
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.push('/terms'),
                            ),
                            const TextSpan(text: ' et la '),
                            TextSpan(
                              text: 'politique de confidentialité',
                              style: const TextStyle(
                                  color: Color(0xFF1A56DB),
                                  fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.push('/privacy'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MsButton(
                  label: 'Créer mon compte',
                  loading: _loading,
                  onPressed: _submit),
              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Text('Déjà un compte ? Se connecter',
                      style: TextStyle(
                          color: Color(0xFF1A56DB),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
