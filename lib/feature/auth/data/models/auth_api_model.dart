import '../../domain/entities/auth_entity.dart';

class AuthApiModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final String provider;

  const AuthApiModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role = 'user',
    this.provider = 'local',
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: (json['id'] ?? json['_id']) as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: (json['avatar'] as String?)?.isEmpty ?? true
          ? null
          : json['avatar'] as String,
      role: json['role'] as String? ?? 'user',
      provider: json['provider'] as String? ?? 'local',
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      avatar: entity.avatar,
      role: entity.role,
      provider: entity.provider,
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      name: name,
      email: email,
      avatar: avatar,
      role: role,
      provider: provider,
    );
  }
}
