import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:unbroken/api/api_endpoints.dart';
import 'package:unbroken/services/storage_service.dart';

class HttpClient extends http.BaseClient {
  static const List<String> _openEndpoints = [ApiEndpoints.login];

  final StorageService storageService;

  HttpClient({required this.storageService});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (kDebugMode) print(request.url.toString());
    if (_openEndpoints.contains(request.url.toString())) {
      return request.send();
    }
    final token = await storageService.getToken();
    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return request.send().timeout(const Duration(seconds: 10));
  }

  Future<http.StreamedResponse> sendMultipart(http.MultipartRequest request) {
    request.headers[HttpHeaders.contentTypeHeader] = "multipart/form-data";
    return send(request);
  }

}
