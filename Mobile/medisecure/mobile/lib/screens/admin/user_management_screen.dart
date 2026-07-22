import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart';
import '../../widgets/ms_shimmer.dart';
import '../../widgets/ms_error_view.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person_add_outlined),
              onPressed: () => _showAddUser(context, ref)),
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(allUsersProvider)),
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) => _UserTile(user: users[i], ref: ref),
        ),
        loading: () => const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: AppointmentListSkeleton(count: 6),
            ),
          ],
        ),
        error: (e, _) => MsErrorView(
            error: e, onRetry: () => ref.invalidate(allUsersProvider)),
      ),
    );
  }

  void _showAddUser(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    final prenomCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    String role = 'patient';
    bool submitting = false;
    String? errorText;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ajouter un utilisateur',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                TextField(
                    controller: prenomCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Prénom', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(
                    controller: nomCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Nom', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Email', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Mot de passe (optionnel, généré si vide)',
                        border: OutlineInputBorder())),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(
                      labelText: 'Rôle', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'patient', child: Text('Patient')),
                    DropdownMenuItem(value: 'doctor', child: Text('Médecin')),
                    DropdownMenuItem(
                        value: 'nurse', child: Text('Infirmier·e')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (v) => setState(() => role = v!),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(errorText!,
                      style: const TextStyle(
                          color: Color(0xFFDC2626), fontSize: 13)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitting
                        ? null
                        : () async {
                            if (emailCtrl.text.trim().isEmpty ||
                                nomCtrl.text.trim().isEmpty ||
                                prenomCtrl.text.trim().isEmpty) {
                              setState(
                                  () => errorText = 'Tous les champs sont requis.');
                              return;
                            }
                            setState(() {
                              submitting = true;
                              errorText = null;
                            });
                            try {
                              await ref.read(adminServiceProvider).createUser(
                                    prenom: prenomCtrl.text.trim(),
                                    nom: nomCtrl.text.trim(),
                                    email: emailCtrl.text.trim(),
                                    role: role,
                                    password: passwordCtrl.text.trim(),
                                  );
                              ref.invalidate(allUsersProvider);
                              if (ctx.mounted) Navigator.pop(ctx);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('✅ Utilisateur créé')));
                              }
                            } catch (e) {
                              setState(() {
                                submitting = false;
                                errorText =
                                    "Échec de la création : ${e.toString()}";
                              });
                            }
                          },
                    child: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Créer le compte'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final WidgetRef ref;
  const _UserTile({required this.user, required this.ref});

  Color _roleColor(String r) => switch (r) {
        'admin' => const Color(0xFF7C3AED),
        'doctor' => const Color(0xFF1A56DB),
        'nurse' => const Color(0xFF0D9488),
        _ => const Color(0xFF16A34A),
      };

  @override
  Widget build(BuildContext context) {
    final initials = '${user.prenom[0]}${user.nom[0]}'.toUpperCase();
    final isSuspended = !user.isActive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: _roleColor(user.role).withOpacity(0.12),
            child: Text(initials,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _roleColor(user.role))),
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
                const SizedBox(height: 4),
                Row(children: [
                  _RoleBadge(role: user.role, color: _roleColor(user.role)),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSuspended
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(isSuspended ? 'Suspendu' : 'Actif',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSuspended
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF16A34A))),
                  ),
                ]),
              ])),
          PopupMenuButton<String>(
            onSelected: (action) async {
              if (action == 'toggle') {
                await ref
                    .read(adminServiceProvider)
                    .setUserActive(user.id, isSuspended);
                ref.invalidate(allUsersProvider);
              } else if (action == 'delete') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Supprimer ?'),
                    content: Text('Supprimer ${user.fullName} ?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler')),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Supprimer',
                              style: TextStyle(color: Color(0xFFDC2626)))),
                    ],
                  ),
                );
                if (ok == true) {
                  await ref.read(adminServiceProvider).deleteUser(user.id);
                  ref.invalidate(allUsersProvider);
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: 'toggle',
                  child: Text(isSuspended ? 'Réactiver' : 'Suspendre')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Supprimer',
                      style: TextStyle(color: Color(0xFFDC2626)))),
            ],
          ),
        ]),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  final Color color;
  const _RoleBadge({required this.role, required this.color});

  String _label(String r) => switch (r) {
        'admin' => 'Admin',
        'doctor' => 'Médecin',
        'nurse' => 'Infirmier',
        _ => 'Patient',
      };

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20)),
        child: Text(_label(role),
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      );
}
