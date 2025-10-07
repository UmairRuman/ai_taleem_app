// lib/core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? code;

  ServerException(this.message, {this.code});
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);
}
