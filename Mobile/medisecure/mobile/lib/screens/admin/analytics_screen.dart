import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/admin_service.dart';
import '../../widgets/ms_error_view.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Rapports & Analytics'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(adminStatsProvider)),
        ],
      ),
      body: statsAsync.when(
        data: (s) {
          final totalUsers = (s['total_users'] as num?)?.toInt() ?? 0;
          final patients = (s['total_patients'] as num?)?.toInt() ?? 0;
          final medecins = (s['total_medecins'] as num?)?.toInt() ?? 0;
          final infirmiers = (s['total_infirmiers'] as num?)?.toInt() ?? 0;
          final admins = (s['total_admins'] as num?)?.toInt() ?? 0;

          final totalRdv = (s['total_rdv'] as num?)?.toInt() ?? 0;
          final confirmes = (s['rdv_confirmes'] as num?)?.toInt() ?? 0;
          final annules = (s['rdv_annules'] as num?)?.toInt() ?? 0;
          final termines = (s['rdv_termines'] as num?)?.toInt() ?? 0;
          final enAttente = (s['pending_appointments'] as num?)?.toInt() ?? 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionTitle('Répartition des utilisateurs'),
                const SizedBox(height: 10),
                _DistributionBar(
                  total: totalUsers,
                  segments: [
                    _Segment('Patients', patients, const Color(0xFF16A34A)),
                    _Segment('Médecins', medecins, const Color(0xFF1A56DB)),
                    _Segment(
                        'Infirmiers', infirmiers, const Color(0xFF0D9488)),
                    _Segment('Admins', admins, const Color(0xFF7C3AED)),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionTitle('Statut des rendez-vous'),
                const SizedBox(height: 10),
                _DistributionBar(
                  total: totalRdv,
                  segments: [
                    _Segment('Confirmés', confirmes, const Color(0xFF16A34A)),
                    _Segment(
                        'En attente', enAttente, const Color(0xFFF59E0B)),
                    _Segment('Terminés', termines, const Color(0xFF64748B)),
                    _Segment('Annulés', annules, const Color(0xFFDC2626)),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionTitle('Chiffres clés'),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _KpiCard(
                        label: 'Utilisateurs',
                        value: totalUsers,
                        icon: Icons.people,
                        color: const Color(0xFF1A56DB)),
                    _KpiCard(
                        label: 'Rendez-vous totaux',
                        value: totalRdv,
                        icon: Icons.calendar_month,
                        color: const Color(0xFF0D9488)),
                    _KpiCard(
                        label: "RDV aujourd'hui",
                        value: (s['appointments_today'] as num?)?.toInt() ?? 0,
                        icon: Icons.today,
                        color: const Color(0xFFF59E0B)),
                    _KpiCard(
                        label: 'RDV en attente',
                        value: enAttente,
                        icon: Icons.pending_outlined,
                        color: const Color(0xFFDC2626)),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            MsErrorView(error: e, onRetry: () => ref.invalidate(adminStatsProvider)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)));
}

class _Segment {
  final String label;
  final int value;
  final Color color;
  _Segment(this.label, this.value, this.color);
}

class _DistributionBar extends StatelessWidget {
  final int total;
  final List<_Segment> segments;
  const _DistributionBar({required this.total, required this.segments});

  @override
  Widget build(BuildContext context) {
    final safeTotal = total == 0 ? 1 : total;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 14,
                child: Row(
                  children: segments
                      .where((s) => s.value > 0)
                      .map((s) => Expanded(
                            flex: s.value,
                            child: Container(color: s.color),
                          ))
                      .toList()
                    ..addAll(total == 0
                        ? [
                            const Expanded(
                                child: ColoredBox(color: Color(0xFFE2E8F0)))
                          ]
                        : []),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: segments
                  .map((s) => Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: s.color, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('${s.label} · ${s.value}',
                            style: const TextStyle(
                                fontSize: 12.5, color: Color(0xFF475569))),
                      ]))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  const _KpiCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text('$value',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11.5, color: Color(0xFF94A3B8))),
            ],
          ),
        ),
      );
}
