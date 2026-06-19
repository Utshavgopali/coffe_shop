import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

// Change this when testing on real phone
  static const bool isPhysicalDevice = true;

// Your laptop IPv4 address
  static const String compIpAddress = '192.168.1.83';

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:3000/api/v1';
    }

    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  static const String register = '/auth/register';

  static const String login = '/auth/login';

  static const String profile = '/auth/profile';

  static const String upload = '/auth/upload';

  // ─── Batch endpoints ───────────────────────────────────────────────────────
  static const String batches = '/batches';

  static String batchById(String id) => '/batches/$id';
}
