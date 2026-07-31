class GoogleAuthConfig {
  GoogleAuthConfig._();

  // Web OAuth 2.0 Client ID from Google Cloud Console. Passed as
  // serverClientId so the ID token's audience matches the value the
  // backend verifies against (coffeeshop_backend .env GOOGLE_CLIENT_ID) —
  // both sides must use the SAME Web client ID or verification fails.
  static const String webClientId =
      'PASTE_WEB_CLIENT_ID_HERE.apps.googleusercontent.com';
}
