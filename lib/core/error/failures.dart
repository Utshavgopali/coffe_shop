abstract class Failure {
  final String message;
  const Failure({required this.message});
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({required super.message});
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure({this.statusCode, required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}