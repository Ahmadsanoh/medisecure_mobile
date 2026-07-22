import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AdminService {
  final _dio = ApiClient().dio;

  Future<Map<String, dynamic>> getStats() async {
    final res = await _dio.get('admin/stats');
    return Map<String, dynamic>.from(res.data);
  }

  Future<List<UserModel>> getAllUsers() async {
    final res = await _dio.get('admin/users');
    return (res.data as List).map((e) => UserModel.fromJson(e)).toList();
  }

  Future<UserModel> createUser({
    required String prenom,
    required String nom,
    required String email,
    required String role,
    String? password,
  }) async {
    final res = await _dio.post('admin/users', data: {
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'role': role,
      if (password != null && password.isNotEmpty) 'password': password,
    });
    return UserModel.fromJson(res.data);
  }

  Future<UserModel> updateUser(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('admin/users/$id', data: data);
    return UserModel.fromJson(res.data);
  }

  /// Suspend ou réactive un compte. Utilise `is_active`, le mécanisme natif
  /// Django : un compte suspendu ne peut plus se connecter (pas juste un
  /// badge visuel côté app).
  Future<UserModel> setUserActive(int id, bool active) async {
    return updateUser(id, {'is_active': active});
  }

  Future<UserModel> changeUserRole(int id, String role) async {
    return updateUser(id, {'role': role});
  }

  Future<void> deleteUser(int id) async {
    await _dio.delete('admin/users/$id');
  }

  Future<List<Map<String, dynamic>>> getLogs({int limit = 100}) async {
    final res = await _dio.get('admin/logs', queryParameters: {'limit': limit});
    return List<Map<String, dynamic>>.from(res.data);
  }
}

final adminServiceProvider = Provider((_) => AdminService());
final adminStatsProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(adminServiceProvider).getStats());
final allUsersProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(adminServiceProvider).getAllUsers());
final logsProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(adminServiceProvider).getLogs());
