import 'package:logger/logger.dart';

/// Centralized logger for MediSecure.
/// Provides a clean implementation for tracing events and scenarios.
final log = MsLogger();

class MsLogger {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // No method count for standard logs
      errorMethodCount: 8, // More detail for errors
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Debug log
  void d(String message) => _logger.d('🔍 $message');

  /// Info log (Scenarios, Events)
  void i(String message) => _logger.i('ℹ️ $message');

  /// Warning log
  void w(String message) => _logger.w('⚠️ $message');

  /// Error log with optional error object and stack trace
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e('❌ $message', error: error, stackTrace: stackTrace);

  /// Trace log (Verbose)
  void v(String message) => _logger.t('📌 $message');
}
