import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_endpoints.dart';

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(connectivity: Connectivity());
});

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({required Connectivity connectivity})
      : _connectivity = connectivity;

  // A generic "device has network" check isn't enough here: the backend is
  // a dev-only LAN address (see ApiEndpoints.compIpAddress), reachable only
  // while this phone is on the same network as the machine running it.
  // Without confirming the backend itself is reachable, "online" screens
  // would still fail every request while looking like they should work.
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.isEmpty || result.every((r) => r == ConnectivityResult.none)) {
      return false;
    }

    return _canReachBackend();
  }

  Future<bool> _canReachBackend() async {
    try {
      final uri = Uri.parse(ApiEndpoints.baseUrl);
      final socket = await Socket.connect(
        uri.host,
        uri.port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}
