import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/record_service.dart';
import '../../widgets/ms_button.dart';

class VitalsFormScreen extends ConsumerStatefulWidget {
  final int patientId;
  const VitalsFormScreen({super.key, required this.patientId});

  @override
  ConsumerState<VitalsFormScreen> createState() => _VitalsFormScreenState();
}

class _VitalsFormScreenState extends ConsumerState<VitalsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _poidsCtrl = TextEditingController();
  final _tailleCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _sysCtrl = TextEditingController();
  final _diaCtrl = TextEditingController();
  final _fcCtrl = TextEditingController();
  final _spo2Ctrl = TextEditingController();
  final _obsCtrl = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signes Vitaux')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Prise des constantes du jour',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _Field(
                        label: 'Poids (kg)',
                        controller: _poidsCtrl,
                        keyboard: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(
                    child: _Field(
                        label: 'Taille (cm)',
                        controller: _tailleCtrl,
                        keyboard: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            _Field(
                label: 'Température (°C)',
                controller: _tempCtrl,
                keyboard: TextInputType.number),
            const SizedBox(height: 16),
            const Text('Tension (mmHg)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                    child: _Field(
                        label: 'Systolique',
                        controller: _sysCtrl,
                        keyboard: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(
                    child: _Field(
                        label: 'Diastolique',
                        controller: _diaCtrl,
                        keyboard: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            _Field(
                label: 'Fréquence Cardiaque (bpm)',
                controller: _fcCtrl,
                keyboard: TextInputType.number),
            const SizedBox(height: 16),
            _Field(
                label: 'Saturation O2 (%)',
                controller: _spo2Ctrl,
                keyboard: TextInputType.number),
            const SizedBox(height: 16),
            _Field(label: 'Observations', controller: _obsCtrl, maxLines: 3),
            const SizedBox(height: 32),
            MsButton(
              label: 'Enregistrer les constantes',
              loading: _loading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final data = {
        'poids': double.tryParse(_poidsCtrl.text),
        'taille': int.tryParse(_tailleCtrl.text),
        'temperature': double.tryParse(_tempCtrl.text),
        'tension_systolique': int.tryParse(_sysCtrl.text),
        'tension_diastolique': int.tryParse(_diaCtrl.text),
        'frequence_cardiaque': int.tryParse(_fcCtrl.text),
        'saturation_oxygene': int.tryParse(_spo2Ctrl.text),
        'observations': _obsCtrl.text,
      };

      await ref.read(recordServiceProvider).addVitals(widget.patientId, data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Constantes enregistrées')));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboard;
  final int maxLines;
  const _Field(
      {required this.label,
      required this.controller,
      this.keyboard = TextInputType.text,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        ),
      );
}
