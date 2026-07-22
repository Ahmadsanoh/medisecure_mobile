class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String? telephone;
  final String statut;
  final bool isActive;
  final DateTime dateCreation;
  final Map<String, dynamic>? patientProfile;
  final Map<String, dynamic>? medecinProfile;

  const UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    this.telephone,
    required this.statut,
    this.isActive = true,
    required this.dateCreation,
    this.patientProfile,
    this.medecinProfile,
  });

  String get fullName => '$prenom $nom';

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        id: (j['id'] as num?)?.toInt() ?? 0,
        nom: j['nom'] as String? ?? '',
        prenom: j['prenom'] as String? ?? '',
        email: j['email'] as String? ?? '',
        role: _normalizeRole(j['role'] as String?),
        telephone: j['telephone'] as String?,
        statut: (j['statut'] is bool)
            ? (j['statut'] ? 'Actif' : 'En attente')
            : (j['statut'] as String? ?? 'Inconnu'),
        isActive: j['is_active'] as bool? ?? true,
        dateCreation: DateTime.parse(j['date_joined'] as String? ??
            j['date_creation'] as String? ??
            DateTime.now().toIso8601String()),
        patientProfile: j['patient_profile'] as Map<String, dynamic>?,
        medecinProfile: j['medecin_profile'] as Map<String, dynamic>?,
      );

  // Le backend renvoie le rôle en majuscules françaises (PATIENT, MEDECIN,
  // INFIRMIER, ADMIN) ; le reste de l'app utilise la convention anglaise en
  // minuscules (patient, doctor, nurse, admin).
  static String _normalizeRole(String? backendRole) {
    switch ((backendRole ?? 'PATIENT').toUpperCase()) {
      case 'MEDECIN':
        return 'doctor';
      case 'INFIRMIER':
        return 'nurse';
      case 'ADMIN':
        return 'admin';
      default:
        return 'patient';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'role': role,
        'telephone': telephone,
        'statut': statut,
        'is_active': isActive,
        'date_creation': dateCreation.toIso8601String(),
        'patient_profile': patientProfile,
        'medecin_profile': medecinProfile,
      };
}
