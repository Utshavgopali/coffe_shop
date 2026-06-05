class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException({required this.message});
}

class ApiException implements Exception {
  final String message;
  const ApiException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({required this.message});
}