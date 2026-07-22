import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_service.dart';

// Base URL is read from .env (API_BASE_URL). See .env.example for the
// per-target values (emulator / LAN device / desktop).
final _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api/';

const _storage = FlutterSecureStorage();

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  /// URL de base de l'API, utile pour l'écran Paramètres système (diagnostic).
  static String get baseUrl => _baseUrl;

  late final Dio _dio;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.addAll([
      _TrailingSlashInterceptor(),
      _AuthInterceptor(_dio),
      _LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.v('📡 REQUEST[${options.method}] => PATH: ${options.path}');
    if (options.data != null) log.d('📦 Payload: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log.i(
        '✅ RESPONSE[${response.statusCode}] => FROM: ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.e(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        err,
        err.stackTrace);
    handler.next(err);
  }
}

class _TrailingSlashInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path.isNotEmpty && !options.path.endsWith('/')) {
      options.path = '${options.path}/';
    }
    handler.next(options);
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio _dio;
  _AuthInterceptor(this._dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    if (err.response?.statusCode == 401 && !alreadyRetried) {
      // Try refresh
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken != null) {
        try {
          final res =
              await _dio.post('auth/refresh', data: {'refresh': refreshToken});
          // Simple JWT returns the tokens under `access` / `refresh`, not
          // `access_token` / `refresh_token` (those names are only used by
          // the login endpoint's custom response shape).
          final newAccess = res.data['access'] as String;
          await _storage.write(key: 'access_token', value: newAccess);
          final newRefresh = res.data['refresh'] as String?;
          if (newRefresh != null) {
            await _storage.write(key: 'refresh_token', value: newRefresh);
          }

          // Retry original request (marked so a second 401 doesn't loop)
          err.requestOptions.extra['retried'] = true;
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
          final retried = await _dio.fetch(err.requestOptions);
          return handler.resolve(retried);
        } catch (_) {
          await _storage.deleteAll(); // force logout
        }
      }
    }
    handler.next(err);
  }
}
