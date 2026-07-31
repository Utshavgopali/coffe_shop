import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/shared_prefs_provider.dart';

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref.read(sharedPreferencesProvider));
});

class SessionService {
  final SharedPreferences _prefs;

  SessionService(this._prefs);

  static const String _lastLoggedInUserId = 'last_logged_in_user_id';
  static const String _biometricUserId = 'biometric_user_id';

  // Whoever most recently completed a real login on this device (normal
  // password login, or a successful biometric restore) — survives
  // logout, since that's what the login screen compares against
  // _biometricUserId to decide whether to show the fingerprint button.
  Future<void> saveLastLoggedInUserId(String userId) {
    return _prefs.setString(_lastLoggedInUserId, userId);
  }

  String? getLastLoggedInUserId() => _prefs.getString(_lastLoggedInUserId);

  // Set/cleared ONLY by the explicit toggle in Profile — never touched by
  // logout — so it correctly survives a logout for the SAME account, but
  // never gets read as "enabled" for a DIFFERENT account that logs in
  // later on the same device.
  Future<void> setBiometricLoginEnabled(bool enabled, {String? userId}) {
    if (enabled && userId != null) {
      return _prefs.setString(_biometricUserId, userId);
    }
    return _prefs.remove(_biometricUserId);
  }

  // True only when fingerprint is bound to the SAME account that most
  // recently logged in on this device.
  bool isBiometricLoginEnabled() {
    final boundUserId = _prefs.getString(_biometricUserId);
    final lastUserId = _prefs.getString(_lastLoggedInUserId);
    return boundUserId != null && boundUserId == lastUserId;
  }

  String? getBiometricBoundUserId() => _prefs.getString(_biometricUserId);
}
