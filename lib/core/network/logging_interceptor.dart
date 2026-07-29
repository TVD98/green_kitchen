import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs every Dio request and response (or error) to the Flutter debug console.
/// Uses [debugPrint] so output is always visible in the terminal / Debug Console
/// when running in debug mode.
///
/// Disabled automatically in release builds via [kReleaseMode].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({bool? enabled}) : enabled = enabled ?? !kReleaseMode;

  /// Set to false to silence all output.
  final bool enabled;

  static const _sep = '--------------------------------------------------';

  // ---------------------------------------------------------------------------
  // Request
  // ---------------------------------------------------------------------------

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      final buf = StringBuffer()
        ..writeln('[API] ┌── REQUEST $_sep')
        ..writeln('[API] │ ${options.method.toUpperCase()}  ${options.uri}')
        ..writeln('[API] │ Headers : ${_formatHeaders(options.headers)}');

      if (options.queryParameters.isNotEmpty) {
        buf.writeln('[API] │ Query   : ${options.queryParameters}');
      }
      if (options.data != null) {
        buf.writeln('[API] │ Body    : ${_formatBody(options.data)}');
      }

      buf.write('[API] └$_sep');
      debugPrint(buf.toString());
    }

    handler.next(options);
  }

  // ---------------------------------------------------------------------------
  // Response
  // ---------------------------------------------------------------------------

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (enabled) {
      final opts = response.requestOptions;
      final buf = StringBuffer()
        ..writeln('[API] ┌── RESPONSE $_sep')
        ..writeln(
          '[API] │ ${response.statusCode} ${response.statusMessage ?? ''}  '
          '${opts.method.toUpperCase()}  ${opts.uri}',
        )
        ..writeln('[API] │ Headers : ${_formatHeaders(response.headers.map)}')
        ..writeln('[API] │ Body    : ${_formatBody(response.data)}')
        ..write('[API] └$_sep');
      debugPrint(buf.toString());
    }

    handler.next(response);
  }

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      final opts = err.requestOptions;
      final buf = StringBuffer()
        ..writeln('[API] ┌── ERROR $_sep')
        ..writeln(
          '[API] │ ${err.response?.statusCode ?? 'N/A'}  '
          '${opts.method.toUpperCase()}  ${opts.uri}',
        )
        ..writeln('[API] │ Type    : ${err.type}')
        ..writeln('[API] │ Message : ${err.message}');

      if (err.response?.data != null) {
        buf.writeln('[API] │ Body    : ${_formatBody(err.response!.data)}');
      }

      buf.write('[API] └$_sep');
      debugPrint(buf.toString());
    }

    handler.next(err);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _formatHeaders(Map<String, dynamic> headers) {
    final sanitized = {
      for (final e in headers.entries)
        e.key: e.key.toLowerCase() == 'authorization'
            ? _maskToken(e.value.toString())
            : e.value,
    };
    return sanitized.toString();
  }

  String _maskToken(String value) {
    final parts = value.split(' ');
    if (parts.length == 2 && parts[1].length > 6) {
      return '${parts[0]} ${parts[1].substring(0, 6)}••••••';
    }
    return '••••••';
  }

  String _formatBody(dynamic body) {
    if (body == null) return 'null';
    final text = body.toString();
    if (text.length > 1000) return '${text.substring(0, 1000)}... [truncated]';
    return text;
  }
}
