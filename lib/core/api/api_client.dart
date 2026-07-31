import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage/token_service.dart';
import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(tokenService: ref.read(tokenServiceProvider)),
);

class ApiClient {
  ApiClient({required TokenService tokenService, Dio? dio})
      : _tokenService = tokenService,
        _dio = dio ?? _createDio();

  final Dio _dio;
  final TokenService _tokenService;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return dio;
  }

  Dio get raw => _dio;

  Future<Options> _authOptions() async {
    final token = await _tokenService.getToken();
    return Options(
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: await _authOptions(),
    );
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
  }) async {
    return _dio.post(path, data: data, options: await _authOptions());
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
  }) async {
    return _dio.put(path, data: data, options: await _authOptions());
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
  }) async {
    return _dio.patch(path, data: data, options: await _authOptions());
  }

  Future<Response<dynamic>> delete(String path) async {
    return _dio.delete(path, options: await _authOptions());
  }

  /// For multipart form submissions (e.g. avatar upload) — caller builds a
  /// [FormData] and picks the verb; the auth header still gets attached.
  Future<Response<dynamic>> putMultipart(
    String path,
    FormData formData,
  ) async {
    return _dio.put(path, data: formData, options: await _authOptions());
  }

  Future<Response<dynamic>> postMultipart(
    String path,
    FormData formData,
  ) async {
    return _dio.post(path, data: formData, options: await _authOptions());
  }
}
