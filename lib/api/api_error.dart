
// This is both network error response and app exception class
// throwing this exception at service layer and handling it on UI level (try/catch
class ApiError implements Exception {
  final String code;
  final String message;
  final int status;

  ApiError(this.code, this.message, this.status);

  ApiError.generic()
      : code = "networkError",
        message = "NetworkError",
        status = 400;

  ApiError.fromJson(Map<String, dynamic> json)
      : code = json['code'] as String,
        message = json['message'] as String,
        status = json['status'] as int;
}
