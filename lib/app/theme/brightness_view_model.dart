import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/shared_prefs_provider.dart';
import '../../core/services/brightness/screen_brightness_service.dart';
import 'brightness_state.dart';

const String _kAutoBrightnessKey = 'auto_brightness_enabled';

// Same lux reference points as the auto dark-theme threshold: a hand
// fully covering the sensor reads ~0-2 lux, a dim room ~10-50, a lit
// room ~100-300, direct sunlight 10,000+. Screen brightness is clamped
// to a floor so it never goes fully black even in total darkness.
const double _kMinLux = 5;
const double _kMaxLux = 1000;
const double _kMinBrightness = 0.1;
const double _kMaxBrightness = 1.0;

final brightnessViewModelProvider =
    NotifierProvider<BrightnessViewModel, BrightnessState>(BrightnessViewModel.new);

// Independent of ThemeViewModel/AppThemeMode on purpose — auto brightness
// and the light/dark theme choice are separate concerns that should both
// be able to run at the same time (e.g. Dark theme selected manually
// while auto brightness keeps adjusting screen brightness).
class BrightnessViewModel extends Notifier<BrightnessState> {
  late SharedPreferences _prefs;
  late ScreenBrightnessService _brightnessService;
  StreamSubscription<int>? _luxSubscription;

  @override
  BrightnessState build() {
    _prefs = ref.read(sharedPreferencesProvider);
    _brightnessService = ref.read(screenBrightnessServiceProvider);

    ref.onDispose(() {
      _luxSubscription?.cancel();
      _brightnessService.reset();
    });

    final enabled = _prefs.getBool(_kAutoBrightnessKey) ?? false;
    if (enabled) {
      _startListening();
    }

    return BrightnessState(autoBrightnessEnabled: enabled);
  }

  Future<void> setEnabled(bool enabled) async {
    await _prefs.setBool(_kAutoBrightnessKey, enabled);
    state = state.copyWith(autoBrightnessEnabled: enabled);

    if (enabled) {
      _startListening();
    } else {
      _luxSubscription?.cancel();
      _luxSubscription = null;
      await _brightnessService.reset();
    }
  }

  Future<void> _startListening() async {
    try {
      final hasSensor = await LightSensor.hasSensor();
      if (!hasSensor) return;

      _luxSubscription?.cancel();
      _luxSubscription = LightSensor.luxStream().listen((lux) {
        _brightnessService.setBrightness(_luxToBrightness(lux));
      });
    } catch (_) {
      // sensor not available / platform doesn't support it — leave
      // brightness untouched
    }
  }

  double _luxToBrightness(int lux) {
    final t = (lux - _kMinLux) / (_kMaxLux - _kMinLux);
    final clamped = t.clamp(0.0, 1.0);
    return _kMinBrightness + clamped * (_kMaxBrightness - _kMinBrightness);
  }
}
