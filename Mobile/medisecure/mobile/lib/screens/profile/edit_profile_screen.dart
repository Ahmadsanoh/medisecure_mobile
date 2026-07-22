import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/auth_service.dart';
import '../../services/api_client.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_text_field.dart';
import '../../widgets/ms_dialog.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _specCtrl = TextEditingController();
  final _cabCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nomCtrl.text = user.nom;
      _prenomCtrl.text = user.prenom;
      _telCtrl.text = user.telephone ?? '';
      if (user.medecinProfile != null) {
        _specCtrl.text = user.medecinProfile!['specialite_nom'] ?? '';
        _cabCtrl.text = user.medecinProfile!['cabinet_nom'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    _specCtrl.dispose();
    _cabCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showConfirmDialog(
      context,
      title: l10n.saveConfirmTitle,
      message: l10n.saveConfirmMessage,
      confirmLabel: l10n.recordsSave,
      confirmColor: const Color(0xFF1A56DB),
    );
    if (!confirm) return;

    setState(() => _loading = true);
    try {
      final user = ref.read(currentUserProvider);
      final Map<String, dynamic> payload = {
        'nom': _nomCtrl.text,
        'prenom': _prenomCtrl.text,
        'telephone': _telCtrl.text,
      };

      if (user?.role == 'doctor') {
        payload['medecin_profile'] = {
          'specialite_name': _specCtrl.text,
          'cabinet_name': _cabCtrl.text,
        };
      }

      await ApiClient().dio.put('/users/me', data: payload);
      await ref.read(authStateProvider.notifier).refreshCurrentUser();
      if (mounted) {
        showSuccessSnackBar(
            context, AppLocalizations.of(context)!.profileUpdated);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.profileEdit)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            MsTextField(
                controller: _prenomCtrl,
                label: AppLocalizations.of(context)!.profileFirstName,
                prefixIcon: Icons.person_outline),
            const SizedBox(height: 14),
            MsTextField(
                controller: _nomCtrl,
                label: AppLocalizations.of(context)!.profileLastName,
                prefixIcon: Icons.person_outline),
            const SizedBox(height: 14),
            MsTextField(
                controller: _telCtrl,
                label: AppLocalizations.of(context)!.profilePhone,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined),
            if (ref.read(currentUserProvider)?.role == 'doctor') ...[
              const SizedBox(height: 14),
              MsTextField(
                  controller: _specCtrl,
                  label: AppLocalizations.of(context)!.profileSpecialty,
                  prefixIcon: Icons.medical_services_outlined),
              const SizedBox(height: 14),
              MsTextField(
                  controller: _cabCtrl,
                  label: AppLocalizations.of(context)!.profileCabinet,
                  prefixIcon: Icons.business_outlined),
            ],
            const SizedBox(height: 24),
            MsButton(
                label: AppLocalizations.of(context)!.recordsSave,
                loading: _loading,
                onPressed: _save),
          ]),
        ),
      );
}
