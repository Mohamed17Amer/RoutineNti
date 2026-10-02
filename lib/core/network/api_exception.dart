import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool sessionExpired;

  const ApiException(
    this.message, {
    this.statusCode,
    this.sessionExpired = false,
  });

  factory ApiException.fromDio(DioException e) {
    final code = e.response?.statusCode;
    final serverMessage = readMessage(e.response?.data);
    if (serverMessage != null) {
      return ApiException(serverMessage, statusCode: code);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Connection timed out, please try again.');
      case DioExceptionType.connectionError:
        return const ApiException('No internet connection.');
      default:
        break;
    }

    if (code != null && code >= 500) {
      return ApiException('Server error, please try again later.',
          statusCode: code);
    }
    return ApiException('Something went wrong.', statusCode: code);
  }

  static String? readMessage(dynamic data) {
    if (data is Map) {
      for (final key in ['message', 'msg', 'error', 'detail']) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
      }
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }

  @override
  String toString() => message;
}
