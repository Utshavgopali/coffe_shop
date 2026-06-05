import 'package:coffeshop_mobile/feature/auth/data/models/auth_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AuthHiveModelAdapter());
  }
}