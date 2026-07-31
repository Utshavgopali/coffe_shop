import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../core/constants/hive_table_constant.dart';
import '../../models/auth_hive_model.dart';
import '../auth_datasource.dart';

class AuthLocalDatasource implements IAuthDataSource {
  // Opening the box reads and decodes every stored frame up front, so a
  // box written by an older/incompatible AuthHiveModel schema (e.g. a
  // dev install predating a field rename) throws here rather than on a
  // specific get/put. Since that exception is otherwise unhandled deep in
  // AuthRepository's call chain, it silently hangs whatever awaited it
  // (splash screen never navigates) instead of surfacing an error — so we
  // self-heal by wiping the box and starting fresh rather than letting a
  // stale on-disk schema brick the app.
  Future<Box<AuthHiveModel>> get _userBox async {
    try {
      return await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBoxName);
    } catch (_) {
      await Hive.deleteBoxFromDisk(HiveTableConstant.userBoxName);
      return Hive.openBox<AuthHiveModel>(HiveTableConstant.userBoxName);
    }
  }

  @override
  Future<void> saveUser(AuthHiveModel model) async {
    final box = await _userBox;
    await box.put(HiveTableConstant.cachedUserKey, model);
  }

  @override
  Future<AuthHiveModel?> getCachedUser() async {
    final box = await _userBox;
    return box.get(HiveTableConstant.cachedUserKey);
  }

  // Deliberately does NOT delete the cached profile: the active auth
  // token (the actually sensitive part) is cleared separately in
  // AuthRemoteDatasource.logout(), and loginWithBiometric() needs this
  // cache to still be here after logout to show the profile instantly
  // post-fingerprint-scan. It's just display data (name/email/avatar),
  // and loginWithBiometric() already refuses to use it unless the
  // fingerprint binding matches the current account.
  @override
  Future<void> clearSession() async {}
}
