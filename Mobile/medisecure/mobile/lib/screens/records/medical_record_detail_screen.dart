import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medisecure/l10n/app_localizations.dart';
import '../../services/record_service.dart';
import '../../services/auth_service.dart';
import '../../models/medical_record_model.dart';
import '../../widgets/ms_button.dart';
import '../../widgets/ms_error_view.dart';
import '../../widgets/ms_shimmer.dart';

class MedicalRecordDetailScreen extends ConsumerWidget {
  final int? patientId;
  const MedicalRecordDetailScreen({super.key, this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    final provider = patientId == null
        ? myRecordProvider
        : FutureProvider.autoDispose<MedicalRecordModel>((ref) =>
            ref.watch(recordServiceProvider).getPatientRecord(patientId!));

    final recordAsync = ref.watch(provider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.recordsTitle),
        actions: [
          IconButton(
            tooltip: 'Exporter PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => _downloadPdf(context, ref, patientId),
          ),
          if (role == 'doctor' || role == 'nurse') ...[
            if (role == 'nurse')
              IconButton(
                tooltip: 'Saisie constantes',
                icon: const Icon(Icons.speed_outlined),
                onPressed: () => context.push('/records/$patientId/vitals'),
              ),
            IconButton(
              tooltip: 'Nouvelle ordonnance',
              icon: const Icon(Icons.medication_outlined),
              onPressed: () =>
                  context.push('/records/prescriptions?patientId=$patientId'),
            ),
            IconButton(
              tooltip: l10n.recordsAddNote,
              icon: const Icon(Icons.note_add_outlined),
              onPressed: () => recordAsync
                  .whenData((r) => _addNote(context, ref, r, provider)),
            ),
          ]
        ],
      ),
      body: recordAsync.when(
        data: (record) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ExpandableSection(
              icon: '👤',
              title: l10n.recordsPersonalInfo,
              color: const Color(0xFFDBEAFE),
              child: Column(children: [
                _Row(label: l10n.recordsId, value: "#${record.id}"),
                _Row(
                    label: l10n.recordsCreatedAt,
                    value:
                        DateFormat('dd/MM/yyyy').format(record.dateCreation)),
              ]),
            ),
            const SizedBox(height: 10),
            _ExpandableSection(
              icon: '🏥',
              title: l10n.recordsAntecedents,
              color: const Color(0xFFFEE2E2),
              child: Text(record.antecedents ?? l10n.recordsNone),
            ),
            const SizedBox(height: 10),
            _ExpandableSection(
              icon: '💊',
              title: l10n.recordsPrescriptions,
              color: const Color(0xFFDCFCE7),
              child: _PrescriptionsList(prescriptions: record.prescriptions),
            ),
            const SizedBox(height: 10),
            _ExpandableSection(
              icon: '📝',
              title: l10n.recordsConsultations,
              color: const Color(0xFFF3E8FF),
              child: _ConsultationsList(consultations: record.consultations),
            ),
            const SizedBox(height: 10),
            _ExpandableSection(
              icon: '🔬',
              title: l10n.recordsLabResults,
              color: const Color(0xFFFEF3C7),
              child: _LabResultsList(results: record.labResults),
            ),
          ],
        ),
        loading: () => const Column(
          children: [
            RecordSectionSkeleton(),
            RecordSectionSkeleton(),
            RecordSectionSkeleton(),
          ],
        ),
        error: (e, _) =>
            MsErrorView(error: e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, WidgetRef ref, int? patientId) async {
    final service = ref.read(recordServiceProvider);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final path = await service.downloadDossierPdf(patientId: patientId);
      messenger.showSnackBar(
        SnackBar(content: Text('PDF sauvegardé : $path'), backgroundColor: const Color(0xFF16A34A)),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _addNote(BuildContext context, WidgetRef ref, MedicalRecordModel record,
      AutoDisposeFutureProvider<MedicalRecordModel> provider) {
    final diagCtrl = TextEditingController();
    final obsCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recordsMedicalNote,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
                controller: diagCtrl,
                decoration: InputDecoration(labelText: l10n.recordsDiagnostic)),
            const SizedBox(height: 12),
            TextField(
                controller: obsCtrl,
                maxLines: 3,
                decoration:
                    InputDecoration(labelText: l10n.recordsObservations)),
            const SizedBox(height: 16),
            MsButton(
              label: l10n.recordsSave,
              onPressed: () async {
                await ref
                    .read(recordServiceProvider)
                    .addConsultation(record.patientId, {
                  'date_consult': DateTime.now().toIso8601String(),
                  'diagnostic': diagCtrl.text,
                  'observations': obsCtrl.text,
                });
                ref.invalidate(provider);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableSection extends StatefulWidget {
  final String icon;
  final String title;
  final Color color;
  final Widget child;
  const _ExpandableSection(
      {required this.icon,
      required this.title,
      required this.color,
      required this.child});
  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _open = false;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          ListTile(
            onTap: () => setState(() => _open = !_open),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: widget.color, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child:
                      Text(widget.icon, style: const TextStyle(fontSize: 18))),
            ),
            title: Text(widget.title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            trailing: Icon(
                _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF64748B)),
          ),
          if (_open)
            Padding(padding: const EdgeInsets.all(16), child: widget.child),
        ]),
      );
}

class _PrescriptionsList extends StatelessWidget {
  final List<PrescriptionModel> prescriptions;
  const _PrescriptionsList({required this.prescriptions});
  @override
  Widget build(BuildContext context) {
    if (prescriptions.isEmpty) {
      return Text(AppLocalizations.of(context)!.recordsNoPrescr);
    }
    return Column(
        children: prescriptions
            .map((p) => ListTile(
                  title: Text(p.medicament,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(p.dosage ?? "",
                      style: const TextStyle(fontSize: 12)),
                  dense: true,
                ))
            .toList());
  }
}

class _ConsultationsList extends StatelessWidget {
  final List<ConsultationModel> consultations;
  const _ConsultationsList({required this.consultations});
  @override
  Widget build(BuildContext context) {
    if (consultations.isEmpty) {
      return Text(AppLocalizations.of(context)!.recordsNoConsult);
    }
    return Column(
        children: consultations
            .map((c) => ListTile(
                  title: Text(c.diagnostic ?? "Consultation",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(DateFormat('dd/MM/yyyy').format(c.dateConsult),
                      style: const TextStyle(fontSize: 12)),
                  dense: true,
                ))
            .toList());
  }
}

class _LabResultsList extends StatelessWidget {
  final List<LabResultModel> results;
  const _LabResultsList({required this.results});
  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Text(AppLocalizations.of(context)!.recordsNoLab);
    }
    return Column(
        children: results
            .map((r) => ListTile(
                  title: Text(r.examen,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text("${r.valeur ?? "--"} ${r.unite ?? ""}",
                      style: const TextStyle(fontSize: 12)),
                  dense: true,
                ))
            .toList());
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ]),
      );
}
