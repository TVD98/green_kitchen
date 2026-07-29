import 'package:dio/dio.dart';

import 'api_exception.dart';

void ensureApiSuccess(Response<Map<String, dynamic>> response) {
  final body = response.data;
  if (body == null) {
    throw const ApiException(statusCode: 500, code: 'ERR_INTERNAL_SERVER');
  }
  final success = body['success'] as bool? ?? true;
  if (!success) {
    throw ApiException(
      statusCode: response.statusCode ?? 400,
      code: (body['code'] as String?) ?? 'ERR_INTERNAL_SERVER',
      message: body['message'] as String?,
    );
  }
}

T parseApiData<T>(
  Response<Map<String, dynamic>> response,
  T Function(Map<String, dynamic> data) parse,
) {
  ensureApiSuccess(response);
  final data = response.data?['data'];
  if (data is Map<String, dynamic>) {
    return parse(data);
  }
  throw const ApiException(statusCode: 500, code: 'ERR_INTERNAL_SERVER');
}

List<T> parseApiDataList<T>(
  Response<Map<String, dynamic>> response,
  T Function(Map<String, dynamic> item) parse,
) {
  ensureApiSuccess(response);
  final data = response.data?['data'];
  if (data is List) {
    return data
        .whereType<Map<String, dynamic>>()
        .map(parse)
        .toList(growable: false);
  }
  throw const ApiException(statusCode: 500, code: 'ERR_INTERNAL_SERVER');
}
