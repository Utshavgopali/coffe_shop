import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/services/storage/token_service.dart';
import '../../models/auth_api_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  Future<AuthApiModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {'name': name, 'email': email, 'password': password},
    );
    return _saveTokenAndParseUser(response);
  }

  Future<AuthApiModel> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return _saveTokenAndParseUser(response);
  }

  Future<AuthApiModel> googleLogin(String idToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.google,
      data: {'idToken': idToken},
    );
    return _saveTokenAndParseUser(response);
  }

  Future<AuthApiModel> _saveTokenAndParseUser(Response response) async {
    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    await _tokenService.saveToken(token);
    return AuthApiModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<AuthApiModel> getCurrentUser() async {
    final response = await _apiClient.get(ApiEndpoints.whoami);
    return AuthApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<AuthApiModel> updateProfile({String? name, File? avatarFile}) async {
    final formData = FormData.fromMap({
      if (name != null) 'name': name,
      if (avatarFile != null)
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split(Platform.pathSeparator).last,
        ),
    });

    final response = await _apiClient.putMultipart(ApiEndpoints.update, formData);
    return AuthApiModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _tokenService.removeToken();
  }

  Future<void> forgotPasswordRequest(String email) async {
    await _apiClient.post(ApiEndpoints.forgotPasswordRequest, data: {'email': email});
  }

  Future<void> forgotPasswordVerify(String email, String code) async {
    await _apiClient.post(
      ApiEndpoints.forgotPasswordVerify,
      data: {'email': email, 'code': code},
    );
  }

  Future<void> forgotPasswordReset(String email, String code, String newPassword) async {
    await _apiClient.post(
      ApiEndpoints.forgotPasswordReset,
      data: {'email': email, 'code': code, 'newPassword': newPassword},
    );
  }

  Future<void> changePasswordRequestCode(String currentPassword) async {
    await _apiClient.post(
      ApiEndpoints.changePasswordRequestCode,
      data: {'currentPassword': currentPassword},
    );
  }

  Future<void> changePasswordConfirm(String code, String newPassword) async {
    await _apiClient.patch(
      ApiEndpoints.changePasswordConfirm,
      data: {'code': code, 'newPassword': newPassword},
    );
  }
}
