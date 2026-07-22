import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';
import 'logger_service.dart';
import '../models/user_model.dart';

const _storage = FlutterSecureStorage();

// ── Auth state ────────────────────────────────────────────────────────────────

class AuthNotifier extends AsyncNotifier<UserModel?> {
  final _dio = ApiClient().dio;

  @override
  Future<UserModel?> build() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) return null;
    try {
      final res = await _dio.get('users/me');
      return UserModel.fromJson(res.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    log.v('🔑 Tentative de connexion pour: $email');
    try {
      final res = await _dio.post('auth/login', data: {
        'email': email,
        'password': password,
      });
      await _storage.write(
          key: 'access_token', value: res.data['access_token']);
      await _storage.write(
          key: 'refresh_token', value: res.data['refresh_token']);
      await _storage.write(key: 'user_role', value: res.data['role']);

      final meRes = await _dio.get('users/me');
      final user = UserModel.fromJson(meRes.data);
      state = AsyncData(user);
      log.i('✅ Connexion réussie: ${user.fullName} (${user.role})');
    } on DioException catch (e) {
      final msg = e.response?.data['detail'] ?? 'Erreur de connexion';
      log.w('⚠️ Échec de connexion: $msg');
      state = AsyncError(msg, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      final role = data['role'] as String;
      final path = switch (role) {
        'doctor' => 'auth/register/medecin/',
        'nurse' => 'auth/register/infirmier/',
        _ => 'auth/register/patient/',
      };
      await _dio.post(path, data: data);
      await login(data['email'] as String, data['password'] as String);
    } on DioException catch (e) {
      final msg = e.response?.data['detail'] ?? 'Erreur d\'inscription';
      state = AsyncError(msg, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    final user = state.value;
    log.i('🚪 Déconnexion: ${user?.fullName ?? 'Utilisateur inconnu'}');
    await _storage.deleteAll();
    state = const AsyncData(null);
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _dio.post('auth/reset-password', data: {
      'token': token,
      'new_password': newPassword,
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post('auth/change-password', data: {
      'current_password': currentPassword,
      'new_password': newPassword,
    });
  }

  Future<List<Map<String, dynamic>>> getMyActivityLog() async {
    final res = await _dio.get('auth/activity-log');
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<void> refreshCurrentUser() async {
    try {
      final res = await _dio.get('users/me');
      state = AsyncData(UserModel.fromJson(res.data));
    } catch (_) {}
  }
}

final authStateProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);

// Helper providers
final currentUserProvider =
    Provider<UserModel?>((ref) => ref.watch(authStateProvider).value);

final userRoleProvider =
    Provider<String>((ref) => ref.watch(currentUserProvider)?.role ?? '');

final myActivityLogProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(authStateProvider.notifier).getMyActivityLog());
