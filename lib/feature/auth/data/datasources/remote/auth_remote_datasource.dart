import 'dart:io';
import 'package:coffeshop_mobile/core/api/api_client.dart';
import 'package:coffeshop_mobile/core/api/api_endpoints.dart';
import 'package:coffeshop_mobile/feature/auth/domain/entities/auth_entity.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDatasource(apiClient: apiClient);
});

class AuthRemoteDatasource {
  final ApiClient _apiClient;

  AuthRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AuthEntity?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        final token = response.data['token'] as String;
        final data = response.data['data'] as Map<String, dynamic>;

        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        return AuthEntity(
          id: data['id'] ?? data['_id'],
          fullName: data['fullName'],
          email: data['email'],
          password: '',
          phone: data['phoneNumber'] ?? data['phone'],
          profilePicture: data['profilePicture'],
        );
      }
    } catch (e) {
      print("Remote login error: $e");
    }
    return null;
  }

  Future<bool> register(AuthEntity entity) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'fullName': entity.fullName,
          'email': entity.email,
          'password': entity.password,
          'phoneNumber': entity.phone ?? '',
        },
      );
      return response.data['success'] == true;
    } catch (e) {
      print("Remote register error: $e");
      return false;
    }
  }

  Future<AuthEntity?> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.profile);
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return AuthEntity(
          id: data['id'] ?? data['_id'],
          fullName: data['fullName'],
          email: data['email'],
          password: '',
          phone: data['phoneNumber'] ?? data['phone'],
          profilePicture: data['profilePicture'],
        );
      }
    } catch (e) {
      print("Remote get profile error: $e");
    }
    return null;
  }

  Future<AuthEntity?> updateProfile(AuthEntity entity) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.profile,
        data: {
          'fullName': entity.fullName,
          'phoneNumber': entity.phone ?? '',
          'profilePicture': entity.profilePicture ?? '',
        },
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        return AuthEntity(
          id: data['id'] ?? data['_id'],
          fullName: data['fullName'],
          email: data['email'],
          password: '',
          phone: data['phoneNumber'] ?? data['phone'],
          profilePicture: data['profilePicture'],
        );
      }
    } catch (e) {
      print("Remote update profile error: $e");
    }
    return null;
  }

  Future<String?> uploadProfilePicture(File file) async {
    try {
      final fileName = file.path.split(Platform.pathSeparator).last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.upload,
        data: formData,
      );

      if (response.data['success'] == true) {
        return response.data['data']['imageUrl'] as String;
      }
    } catch (e) {
      print("Remote file upload error: $e");
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
