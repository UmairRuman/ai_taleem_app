// lib/core/errors/error_handler.dart
import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ServerException) {
      return ServerFailure(error.message, code: error.code);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is AuthenticationException) {
      return AuthenticationFailure(error.message);
    } else {
      return UnknownFailure(
        'An unexpected error occurred: ${error.toString()}',
      );
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return const ServerFailure('Certificate verification failed');

      case DioExceptionType.unknown:
      default:
        return NetworkFailure('Network error: ${error.message}');
    }
  }

  static Failure _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final message = response?.data?['message'] ?? 'Unknown error occurred';

    switch (statusCode) {
      case 400:
        return ValidationFailure(message, code: statusCode);
      case 401:
        return AuthenticationFailure(
          'Unauthorized. Please login again.',
          code: statusCode,
        );
      case 403:
        return const AuthenticationFailure('Access forbidden');
      case 404:
        return ServerFailure('Resource not found', code: statusCode);
      case 500:
      case 502:
      case 503:
        return const ServerFailure('Server error. Please try again later.');
      default:
        return ServerFailure(message, code: statusCode);
    }
  }

  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}
