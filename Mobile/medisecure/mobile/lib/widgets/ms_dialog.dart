import 'package:flutter/material.dart';

/// Affiche un dialog de confirmation (Oui / Non) et retourne true/false.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  Color confirmColor = const Color(0xFFDC2626),
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: Text(message,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(cancelLabel,
              style: const TextStyle(color: Color(0xFF64748B))),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel,
              style:
                  TextStyle(color: confirmColor, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Affiche un dialog d'information avec un seul bouton OK.
Future<void> showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String okLabel = 'OK',
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: Text(message,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(okLabel,
              style: const TextStyle(
                  color: Color(0xFF1A56DB), fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

/// SnackBar succès standardisé.
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: const Color(0xFF16A34A),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(12),
  ));
}

/// SnackBar erreur standardisé avec message lisible.
void showErrorSnackBar(BuildContext context, Object error) {
  final msg = _friendlyError(error);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: const Color(0xFFDC2626),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(12),
  ));
}

String _friendlyError(Object e) {
  final s = e.toString();
  if (s.contains('SocketException') || s.contains('connection')) {
    return 'Pas de connexion réseau.';
  }
  if (s.contains('401')) return 'Session expirée, reconnectez-vous.';
  if (s.contains('403')) return 'Accès non autorisé.';
  if (s.contains('404')) return 'Ressource introuvable.';
  if (s.contains('409')) return 'Conflit : ce créneau est déjà pris.';
  if (s.contains('500')) return 'Erreur serveur, réessayez plus tard.';
  return 'Une erreur est survenue.';
}
