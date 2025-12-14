abstract class AppException implements Exception {
  final String message;
  final String? code;
  const AppException({required this.message, this.code});

  @override
  String toString() {
    return "${code ?? ''} ${code != null ? ': ' : ''}$message";
  }
}

class ServerException extends AppException {
  const ServerException({required super.message, super.code});
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.code});
}
