import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';

class MyActivityLogScreen extends ConsumerWidget {
  const MyActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(myActivityLogProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mon activité'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(myActivityLogProvider)),
        ],
      ),
      body: logsAsync.when(
        data: (logs) => logs.isEmpty
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                        child: const Icon(Icons.history,
                            size: 40, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 16),
                      const Text('Aucune activité',
                          style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('Vos actions récentes s\'afficheront ici.',
                          style: TextStyle(
                              color: Color(0xFF64748B), fontSize: 13)),
                    ]),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) => _MyLogTile(log: logs[i]),
              ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: AppointmentListSkeleton(count: 8),
        ),
        error: (e, _) => MsErrorView(
            error: e, onRetry: () => ref.invalidate(myActivityLogProvider)),
      ),
    );
  }
}

class _MyLogTile extends StatelessWidget {
  final Map<String, dynamic> log;
  const _MyLogTile({required this.log});

  IconData _iconFor(String action) {
    final a = action.toLowerCase();
    if (a.contains('connexion')) return Icons.login;
    if (a.contains('mot de passe')) return Icons.lock_reset;
    if (a.contains('déconnexion')) return Icons.logout;
    if (a.contains('rendez-vous') || a.contains('rdv')) {
      return Icons.calendar_month;
    }
    return Icons.history;
  }

  @override
  Widget build(BuildContext context) {
    final action = log['action'] as String? ?? '';
    final ip = log['adresse_ip'] as String? ?? '—';
    final ts = log['date_action'] as String?;
    DateTime? dt;
    try {
      dt = ts != null ? DateTime.parse(ts) : null;
    } catch (_) {}

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(_iconFor(action), size: 18, color: const Color(0xFF1A56DB)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(action,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B))),
                const SizedBox(height: 3),
                Row(children: [
                  const Icon(Icons.computer,
                      size: 12, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 3),
                  Text(ip,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF94A3B8))),
                ]),
                if (dt != null) ...[
                  const SizedBox(height: 2),
                  Text(DateFormat('dd/MM/yyyy HH:mm:ss').format(dt.toLocal()),
                      style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFCBD5E1),
                          fontWeight: FontWeight.w600)),
                ],
              ])),
        ]),
      ),
    );
  }
}
