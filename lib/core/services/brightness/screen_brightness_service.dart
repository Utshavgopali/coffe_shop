import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';

final screenBrightnessServiceProvider = Provider<ScreenBrightnessService>((ref) {
  return ScreenBrightnessService();
});

class ScreenBrightnessService {
  final ScreenBrightness _screenBrightness = ScreenBrightness();

  // App-scoped brightness (not system-wide), so no WRITE_SETTINGS
  // permission is needed and this never touches the user's brightness
  // outside the app.
  Future<void> setBrightness(double brightness) async {
    try {
      await _screenBrightness.setApplicationScreenBrightness(brightness.clamp(0.0, 1.0));
    } catch (_) {
      // brightness control not available on this device — ignore
    }
  }

  Future<void> reset() async {
    try {
      await _screenBrightness.resetApplicationScreenBrightness();
    } catch (_) {}
  }
}
