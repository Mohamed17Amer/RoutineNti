import 'dart:async';

import 'package:dio/dio.dart';
import 'package:my_creative_routine/core/navigation/app_navigator.dart';
import 'package:my_creative_routine/core/network/api_exception.dart';
import 'package:my_creative_routine/core/network/end_points.dart';
import 'package:my_creative_routine/core/storage/token_storage.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );

  Completer<bool>? _refreshing;

  Future<dynamic> get(String path) {
    return _send(
        (headers) => _dio.get(path, options: Options(headers: headers)));
  }

  Future<dynamic> delete(String path) {
    return _send(
        (headers) => _dio.delete(path, options: Options(headers: headers)));
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) {
    return _send(
      (headers) async => _dio.post(
        path,
        data: await _toFormData(body),
        options: Options(headers: headers),
      ),
      withAuth: withAuth,
    );
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) {
    return _send(
      (headers) async => _dio.put(
        path,
        data: await _toFormData(body),
        options: Options(headers: headers),
      ),
    );
  }

  Future<dynamic> _send(
    Future<Response> Function(Map<String, String> headers) request, {
    bool withAuth = true,
  }) async {
    try {
      final response = await request(await _headers(withAuth));
      return response.data;
    } on DioException catch (e) {
      final unauthorized = e.response?.statusCode == 401;
      if (!withAuth || !unauthorized) throw ApiException.fromDio(e);

      final refreshed = await _refreshAccessToken();
      if (!refreshed) {
        await TokenStorage.clear();
        AppNavigator.goToLogin(
            message: 'Your session has expired, please log in again.');
        throw const ApiException('Session expired', sessionExpired: true);
      }

      try {
        final response = await request(await _headers(true));
        return response.data;
      } on DioException catch (retryError) {
        throw ApiException.fromDio(retryError);
      }
    }
  }

  Future<Map<String, String>> _headers(bool withAuth) async {
    if (!withAuth) return {};
    final token = await TokenStorage.getAccessToken();
    if (token == null || token.isEmpty) return {};
    return {'Authorization': 'Bearer $token'};
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshing != null) return _refreshing!.future;
    final completer = Completer<bool>();
    _refreshing = completer;

    var success = false;
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await _dio.post(
          EndPoints.refreshToken,
          options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
        );
        final newToken = findValue(response.data, 'access_token');
        final newRefresh = findValue(response.data, 'refresh_token');
        if (newToken is String && newToken.isNotEmpty) {
          await TokenStorage.saveTokens(
            accessToken: newToken,
            refreshToken: newRefresh is String ? newRefresh : null,
          );
          success = true;
        }
      }
    } catch (_) {
      success = false;
    }

    completer.complete(success);
    _refreshing = null;
    return success;
  }

  Future<FormData?> _toFormData(Map<String, dynamic>? body) async {
    if (body == null) return null;
    final fields = <String, dynamic>{};
    for (final entry in body.entries) {
      final value = entry.value;
      if (value == null) continue;
      if (value is PickedImage) {
        fields[entry.key] =
            MultipartFile.fromBytes(value.bytes, filename: value.name);
      } else {
        fields[entry.key] = value.toString();
      }
    }
    return FormData.fromMap(fields);
  }

  static dynamic findValue(dynamic json, String key) {
    if (json is! Map) return null;
    if (json[key] != null) return json[key];
    for (final wrapper in ['data', 'user', 'tokens', 'task']) {
      final nested = json[wrapper];
      if (nested is Map && nested[key] != null) return nested[key];
    }
    return null;
  }

  static String? imageUrl(dynamic path) {
    if (path is! String || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final base = Uri.parse(EndPoints.baseUrl);
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${base.scheme}://${base.authority}/$cleanPath';
  }
}
