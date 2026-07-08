import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'logger_service.dart';

class NurseService {
  final _dio = ApiClient().dio;

  Future<void> registerPatient({
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    log.v('🏥 Nurse: Enregistrement d\'un nouveau patient: $prenom $nom');
    try {
      await _dio.post('auth/register/patient/', data: {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'password': password,
        'role': 'PATIENT',
      });
      log.i('✅ Patient enregistré avec succès: $email');
    } catch (e) {
      log.e('❌ Échec de l\'enregistrement patient: $e');
      rethrow;
    }
  }
}

final nurseServiceProvider = Provider((ref) => NurseService());
