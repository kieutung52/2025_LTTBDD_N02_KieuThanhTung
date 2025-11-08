import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../interceptors/auth_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient(this._dio, this._storage) {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 240);
    _dio.options.receiveTimeout = const Duration(seconds: 240);

    _dio.interceptors.add(AuthInterceptor(_storage));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      log('BaseURL: ${_dio.options.baseUrl}');

      final response = await _dio.get(path, queryParameters: queryParams);
      log('GET thành công: ${response.data}');
      return response;
    } on DioException catch (e) {
      log('ApiClient GET Error', error: e, name: 'ApiClient');
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      log('BaseURL: ${_dio.options.baseUrl}');

      final response = await _dio.post(path, data: data);
      
      log('POST thành công: ${response.data}');
      return response;
    } on DioException catch (e) {
      log('ApiClient POST Error', error: e, name: 'ApiClient');
      rethrow;
    } catch (e) {
      log('Unexpected Error: $e');
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      log('BaseURL: ${_dio.options.baseUrl}');

      final response = await _dio.put(path, data: data);

      log('PUT thành công: ${response.data}');
      return response;
    } on DioException catch (e) {
      log('ApiClient PUT Error', error: e, name: 'ApiClient');
      rethrow;
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      log('BaseURL: ${_dio.options.baseUrl}');

      final response = await _dio.delete(path, data: data);

      log('DELETE thành công: ${response.data}');
      return response;
    } on DioException catch (e) {
      log('ApiClient DELETE Error', error: e, name: 'ApiClient');
      rethrow;
    }
  }
}