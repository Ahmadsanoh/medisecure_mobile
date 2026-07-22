import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';

const _roles = [
  ('patient', 'Patient', Color(0xFF16A34A)),
  ('doctor', 'Médecin', Color(0xFF1A56DB)),
  ('nurse', 'Infirmier·e', Color(0xFF0D9488)),
  ('admin', 'Admin', Color(0xFF7C3AED)),
];

class RbacScreen extends ConsumerWidget {
  const RbacScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Rôles & Permissions'),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(allUsersProvider)),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFEFF6FF),
            padding: const EdgeInsets.all(14),
            child: const Text(
              'Patient, Médecin, Infirmier et Admin : chaque rôle donne accès à '
              'un ensemble de fonctionnalités distinct dans l\'app. Modifier le '
              'rôle d\'un utilisateur ici prend effet immédiatement.',
              style: TextStyle(fontSize: 12.5, color: Color(0xFF1E40AF)),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _RoleTile(user: users[i], ref: ref),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: AppointmentListSkeleton(count: 6),
              ),
              error: (e, _) => MsErrorView(
                  error: e, onRetry: () => ref.invalidate(allUsersProvider)),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleTile extends StatefulWidget {
  final UserModel user;
  final WidgetRef ref;
  const _RoleTile({required this.user, required this.ref});

  @override
  State<_RoleTile> createState() => _RoleTileState();
}

class _RoleTileState extends State<_RoleTile> {
  bool _saving = false;

  Color _colorFor(String role) =>
      _roles.firstWhere((r) => r.$1 == role, orElse: () => _roles[0]).$3;

  Future<void> _changeRole(String newRole) async {
    if (newRole == widget.user.role) return;
    setState(() => _saving = true);
    try {
      await widget.ref
          .read(adminServiceProvider)
          .changeUserRole(widget.user.id, newRole);
      widget.ref.invalidate(allUsersProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec : $e')));
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _colorFor(user.role).withOpacity(0.12),
            child: Text('${user.prenom[0]}${user.nom[0]}'.toUpperCase(),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _colorFor(user.role))),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              Text(user.email,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          )),
          _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : DropdownButton<String>(
                  value: user.role,
                  underline: const SizedBox(),
                  items: _roles
                      .map((r) => DropdownMenuItem(
                          value: r.$1,
                          child: Text(r.$2,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: r.$3))))
                      .toList(),
                  onChanged: (v) => v == null ? null : _changeRole(v),
                ),
        ]),
      ),
    );
  }
}
