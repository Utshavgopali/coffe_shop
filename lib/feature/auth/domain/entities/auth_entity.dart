import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final String provider;

  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.role = 'user',
    this.provider = 'local',
  });

  @override
  List<Object?> get props => [id, name, email, avatar, role, provider];
}
