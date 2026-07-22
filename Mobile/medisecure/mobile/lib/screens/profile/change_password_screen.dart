import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_text_field.dart';
import '../../widgets/ms_dialog.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  ConsumerState<ChangePasswordScreen> createState() => _State();
}

class _State extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateNew(String? v) {
    if (v == null || v.isEmpty) return 'Champ requis';
    if (v.length < 8) return 'Au moins 8 caractères';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _newCtrl.text) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).changePassword(
            currentPassword: _currentCtrl.text,
            newPassword: _newCtrl.text,
          );
      if (!mounted) return;
      setState(() => _loading = false);
      await showInfoDialog(context,
          title: 'Mot de passe mis à jour',
          message: 'Votre mot de passe a été changé avec succès.');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Choisissez un nouveau mot de passe d\'au moins 8 caractères.',
                  style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 24),
              MsTextField(
                controller: _currentCtrl,
                label: 'Mot de passe actuel',
                obscureText: true,
                prefixIcon: Icons.lock_outline,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              MsTextField(
                controller: _newCtrl,
                label: 'Nouveau mot de passe',
                obscureText: true,
                prefixIcon: Icons.lock_reset_outlined,
                validator: _validateNew,
              ),
              const SizedBox(height: 16),
              MsTextField(
                controller: _confirmCtrl,
                label: 'Confirmer le nouveau mot de passe',
                obscureText: true,
                prefixIcon: Icons.check_circle_outline,
                validator: _validateConfirm,
              ),
              const SizedBox(height: 24),
              MsButton(
                  label: 'Mettre à jour',
                  loading: _loading,
                  onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
