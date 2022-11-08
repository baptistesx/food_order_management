abstract class AppException implements Exception {
  String message;

  AppException(
    this.message,
  );
}

class ApiResponseException extends AppException {
  int code;
  String reason;

  ApiResponseException({
    String? message,
    int? code,
    String? reason,
  })  : code = code ?? 0,
        reason = reason ?? 'No reason specified',
        super(
          message = message ?? 'No message specified',
        );
}

class StandardException extends AppException {
  StandardException(String? message)
      : super(
          message ?? 'No message specified',
        );
}
