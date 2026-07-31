import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthHiveModelAdapter());
  }
}
