import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_auth_config.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: GoogleAuthConfig.webClientId,
  );

  /// Returns the Google ID token for the backend to verify, or null if the
  /// user cancelled the account picker.
  ///
  /// The native SDK throws a PlatformException (rather than just returning
  /// null) for setup problems like an unregistered SHA-1/OAuth client — that
  /// needs to surface as a normal failure, not an unhandled async error that
  /// leaves the caller's loading state stuck forever.
  Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;
      final auth = await account.authentication;
      return auth.idToken;
    } on PlatformException catch (e) {
      throw Exception(e.message ?? 'Google sign-in failed');
    }
  }

  /// Clears the cached Google session so the account picker shows again
  /// next time instead of silently re-using the last chosen account.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
