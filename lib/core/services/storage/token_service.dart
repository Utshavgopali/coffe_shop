import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(ref.read(secureStorageProvider));
});

class TokenService {
  final FlutterSecureStorage _secureStorage;

  static const String _tokenKey = 'auth_token';

  // The active token above gets wiped on every logout, so fingerprint
  // login needs its own durable copy — stashed per-account when the user
  // enables it in Profile, independent of the normal login/logout cycle.
  static const String _biometricTokenPrefix = 'biometric_token_';

  TokenService(this._secureStorage);

  Future<void> saveToken(String token) {
    return _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<void> removeToken() {
    return _secureStorage.delete(key: _tokenKey);
  }

  Future<void> saveBiometricToken(String userId, String token) {
    return _secureStorage.write(key: '$_biometricTokenPrefix$userId', value: token);
  }

  Future<String?> getBiometricToken(String userId) {
    return _secureStorage.read(key: '$_biometricTokenPrefix$userId');
  }

  Future<void> removeBiometricToken(String userId) {
    return _secureStorage.delete(key: '$_biometricTokenPrefix$userId');
  }
}
