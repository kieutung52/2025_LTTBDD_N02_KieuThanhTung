import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path == '/login' || options.path == '/register') {
      return handler.next(options);
    }

    final token = await _storage.read(key: 'jwt_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log(
        "Token hết hạn hoặc không hợp lệ, đăng xuất người dùng.",
        name: "AuthInterceptor",
      );
      await _storage.delete(key: 'jwt_token');
    }

    return handler.next(err);
  }
}