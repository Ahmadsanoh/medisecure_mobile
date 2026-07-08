import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medisecure/l10n/app_localizations.dart';

import '../../services/record_service.dart';
import '../../widgets/ms_error_view.dart';
import '../../widgets/ms_shimmer.dart';

class DoctorRecordsScreen extends ConsumerStatefulWidget {
  const DoctorRecordsScreen({super.key});
  @override
  ConsumerState<DoctorRecordsScreen> createState() =>
      _DoctorRecordsScreenState();
}

class _DoctorRecordsScreenState extends ConsumerState<DoctorRecordsScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final patientsAsync = ref.watch(patientsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(l10n.navRecords),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Rechercher un patient...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(patientsProvider),
              child: patientsAsync.when(
                data: (patients) {
                  final filtered = patients.where((p) {
                    final fullName = "${p['prenom']} ${p['nom']}".toLowerCase();
                    return fullName.contains(_searchQuery) ||
                        (p['email'] as String)
                            .toLowerCase()
                            .contains(_searchQuery);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text("Aucun patient trouvé",
                          style: TextStyle(color: Color(0xFF94A3B8))),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final p = filtered[i];
                      return _PatientItem(
                        name: "${p['prenom']} ${p['nom']}",
                        id: p['id'],
                        email: p['email'],
                        onTap: () => context.push('/records/${p['id']}'),
                      );
                    },
                  );
                },
                loading: () => const PatientListSkeleton(),
                error: (e, _) => MsErrorView(
                    error: e, onRetry: () => ref.invalidate(patientsProvider)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientItem extends StatelessWidget {
  final String name;
  final int id;
  final String email;
  final VoidCallback onTap;

  const _PatientItem({
    required this.name,
    required this.id,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A56DB).withOpacity(0.1),
          child: Text(name[0],
              style: const TextStyle(
                  color: Color(0xFF1A56DB), fontWeight: FontWeight.w700)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(email, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
        onTap: onTap,
      ),
    );
  }
}
