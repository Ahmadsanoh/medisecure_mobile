import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class SpecialtyModel {
  final int id;
  final String nom;
  const SpecialtyModel({required this.id, required this.nom});
  factory SpecialtyModel.fromJson(Map<String, dynamic> j) =>
      SpecialtyModel(id: j['id'] as int, nom: j['nom'] as String);
}

class DoctorModel {
  final int id;
  final int userId;
  final String nom;
  final String prenom;
  final String? rating;
  final String? bio;
  final SpecialtyModel? specialty;

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.nom,
    required this.prenom,
    this.rating,
    this.bio,
    this.specialty,
  });

  String get fullName => 'Dr. $prenom $nom';

  factory DoctorModel.fromJson(Map<String, dynamic> j) {
    final user = j['user'] as Map<String, dynamic>;
    final spec = j['specialty'] as Map<String, dynamic>?;
    return DoctorModel(
      id: j['id'] as int,
      userId: j['user_id'] as int,
      nom: user['nom'] as String,
      prenom: user['prenom'] as String,
      rating: j['rating'] as String?,
      bio: j['bio'] as String?,
      specialty: spec != null ? SpecialtyModel.fromJson(spec) : null,
    );
  }
}

class PatientProfileModel {
  final int id;
  final int userId;
  final String? email;
  final String? nom;
  final String? prenom;
  final String? dateNaissance;
  final String? sexe;
  final String? adresse;
  final String? groupeSanguin;

  const PatientProfileModel({
    required this.id,
    required this.userId,
    this.email,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.sexe,
    this.adresse,
    this.groupeSanguin,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> j) =>
      PatientProfileModel(
        id: j['id'] as int,
        userId: j['user_id'] as int,
        email: j['email'] as String?,
        nom: j['nom'] as String?,
        prenom: j['prenom'] as String?,
        dateNaissance: j['date_naissance'] as String?,
        sexe: j['sexe'] as String?,
        adresse: j['adresse'] as String?,
        groupeSanguin: j['groupe_sanguin'] as String?,
      );
}

// ── Service ───────────────────────────────────────────────────────────────────

class UserService {
  final _dio = ApiClient().dio;

  Future<List<SpecialtyModel>> getSpecialties() async {
    final res = await _dio.get('users/specialties');
    return (res.data as List).map((e) => SpecialtyModel.fromJson(e)).toList();
  }

  Future<List<DoctorModel>> getDoctors({int? specialtyId}) async {
    final res = await _dio.get(
      'users/doctors',
      queryParameters:
          specialtyId != null ? {'specialty_id': specialtyId} : null,
    );
    return (res.data as List).map((e) => DoctorModel.fromJson(e)).toList();
  }

  Future<PatientProfileModel> getPatientProfile() async {
    final res = await _dio.get('users/patient/profile');
    return PatientProfileModel.fromJson(res.data);
  }

  Future<void> updatePatientProfile({
    String? dateNaissance,
    String? sexe,
    String? adresse,
    String? groupeSanguin,
  }) async {
    final payload = <String, dynamic>{};
    if (dateNaissance != null) payload['date_naissance'] = dateNaissance;
    if (sexe != null) payload['sexe'] = sexe;
    if (adresse != null) payload['adresse'] = adresse;
    if (groupeSanguin != null) payload['groupe_sanguin'] = groupeSanguin;
    await _dio.put('users/patient/profile', data: payload);
  }

  Future<void> updateMe({
    String? nom,
    String? prenom,
    String? telephone,
  }) async {
    final payload = <String, dynamic>{};
    if (nom != null) payload['nom'] = nom;
    if (prenom != null) payload['prenom'] = prenom;
    if (telephone != null) payload['telephone'] = telephone;
    await _dio.put('users/me', data: payload);
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────

final userServiceProvider = Provider((_) => UserService());

final specialtiesProvider = FutureProvider<List<SpecialtyModel>>(
    (ref) => ref.watch(userServiceProvider).getSpecialties());

final doctorsProvider = FutureProvider.family<List<DoctorModel>, int?>(
    (ref, specialtyId) =>
        ref.watch(userServiceProvider).getDoctors(specialtyId: specialtyId));

final patientProfileProvider = FutureProvider<PatientProfileModel>(
    (ref) => ref.watch(userServiceProvider).getPatientProfile());
