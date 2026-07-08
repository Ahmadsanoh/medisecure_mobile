import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medisecure/l10n/app_localizations.dart';
import '../../services/record_service.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_text_field.dart';
import '../../widgets/ms_dialog.dart';

class PrescriptionScreen extends ConsumerStatefulWidget {
  final int? patientId;
  const PrescriptionScreen({super.key, this.patientId});
  @override
  ConsumerState<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends ConsumerState<PrescriptionScreen> {
  final _medCtrl = TextEditingController();
  final _dosCtrl = TextEditingController();
  final _posCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _medCtrl.dispose();
    _dosCtrl.dispose();
    _posCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_medCtrl.text.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showConfirmDialog(
      context,
      title: l10n.prescriptionConfirmTitle,
      message: l10n.prescriptionConfirmMessage,
      confirmLabel: "Émettre l'ordonnance",
      confirmColor: const Color(0xFF16A34A),
    );
    if (!confirm) return;

    setState(() => _loading = true);
    try {
      final pid = widget.patientId ??
          (await ref.read(recordServiceProvider).getMyRecord()).patientId;
      await ref.read(recordServiceProvider).addPrescription(pid, {
        'medicament': _medCtrl.text,
        'dosage': _dosCtrl.text,
        'posologie': _posCtrl.text,
        'date_debut': DateTime.now().toIso8601String().split('T').first,
      });
      ref.invalidate(myRecordProvider);
      if (mounted) {
        showSuccessSnackBar(context, 'Ordonnance créée et envoyée');
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
        appBar: AppBar(title: const Text('Nouvelle ordonnance')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MsTextField(
                controller: _medCtrl,
                label: 'Médicament',
                hint: 'Ex: Amoxicilline 500mg',
                prefixIcon: Icons.medication_outlined),
            const SizedBox(height: 14),
            MsTextField(
                controller: _dosCtrl,
                label: 'Dosage',
                hint: 'Ex: 500mg',
                prefixIcon: Icons.colorize_outlined),
            const SizedBox(height: 14),
            MsTextField(
                controller: _posCtrl,
                label: 'Posologie',
                hint: 'Ex: 1 comprimé 3x/jour pendant 7 jours',
                prefixIcon: Icons.schedule_outlined),
            const SizedBox(height: 24),
            MsButton(
                label: "Émettre l'ordonnance",
                loading: _loading,
                onPressed: _submit),
          ]),
        ),
      );
}
