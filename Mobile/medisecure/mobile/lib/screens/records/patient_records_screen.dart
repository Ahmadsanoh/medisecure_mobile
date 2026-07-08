import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/record_service.dart';
import '../../widgets/ms_error_view.dart';
import '../../widgets/section_header.dart';

class PatientRecordsScreen extends ConsumerWidget {
  const PatientRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(myRecordProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.navRecords),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(myRecordProvider),
        child: recordAsync.when(
          data: (record) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _InfoCard(
                title: l10n.recordsPersonalInfo,
                children: [
                  _InfoRow(label: l10n.recordsId, value: "#${record.id}"),
                  _InfoRow(
                      label: l10n.recordsCreatedAt,
                      value:
                          DateFormat('dd/MM/yyyy').format(record.dateCreation)),
                ],
              ),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.recordsConsultations),
              if (record.consultations.isEmpty)
                _EmptyState(text: l10n.recordsNoConsult)
              else
                ...record.consultations.map((c) => _HistoryCard(
                      title: c.diagnostic ?? "Consultation",
                      subtitle: c.observations ?? "",
                      date: DateFormat('dd/MM/yyyy').format(c.dateConsult),
                    )),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.recordsPrescriptions),
              if (record.prescriptions.isEmpty)
                _EmptyState(text: l10n.recordsNoPrescr)
              else
                ...record.prescriptions.map((p) => _GenericCard(
                      title: p.medicament,
                      subtitle: p.dosage ?? "",
                      bottom: p.posologie,
                    )),
              const SizedBox(height: 24),
              SectionHeader(title: l10n.recordsLabResults),
              if (record.labResults.isEmpty)
                _EmptyState(text: l10n.recordsNoLab)
              else
                ...record.labResults.map((l) => _GenericCard(
                      title: l.examen,
                      subtitle: "${l.valeur ?? "--"} ${l.unite ?? ""}",
                      date: l.dateExamen != null
                          ? DateFormat('dd/MM/yyyy').format(l.dateExamen!)
                          : null,
                    )),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => MsErrorView(
              error: e, onRetry: () => ref.invalidate(myRecordProvider)),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  const _HistoryCard(
      {required this.title, required this.subtitle, required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: Text(date,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ),
    );
  }
}

class _GenericCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? bottom;
  final String? date;
  const _GenericCard(
      {required this.title, required this.subtitle, this.bottom, this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                if (date != null)
                  Text(date!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
            Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
            if (bottom != null && bottom!.isNotEmpty) ...[
              const Divider(),
              Text(bottom!, style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(text,
          style: const TextStyle(
              color: Color(0xFF94A3B8), fontStyle: FontStyle.italic)),
    );
  }
}
