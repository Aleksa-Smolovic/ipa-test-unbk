import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:unbroken/api/http_client.dart';

import 'api_error.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<dynamic> get(String url) async {
    try {
      final response = await client.get(Uri.parse(url),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.value});
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) print('Error: $e}');
      throw ApiError.generic();
    }
  }

  Future<dynamic> post(String url, {dynamic body}) async {
    try {
      final response = await client.post(Uri.parse(url),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
          body: jsonEncode(body));
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw ApiError.generic();
    }
  }

  Future<dynamic> put(String url, {dynamic body}) async {
    try {
      if (kDebugMode) print('Body: ${jsonEncode(body)}');
      final response = await client.put(Uri.parse(url),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.value},
          body: jsonEncode(body));
      return _handleResponse(response);
    } on SocketException catch (e) {
      throw ApiError.generic();
    }
  }

  Future<dynamic> putWithFile(
    String url, {
    dynamic body,
    String? bodyFieldName,
    File? file,
    String? fileFieldName,
  }) async {
    try {
      if (kDebugMode) print('Body: ${jsonEncode(body)}');
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      if (file != null && fileFieldName != null) {
        request.files
            .add(await http.MultipartFile.fromPath(fileFieldName, file.path));
      }
      if (body != null && bodyFieldName != null) {
        request.fields[bodyFieldName] = jsonEncode(body);
      }

      final response = await (client as HttpClient).sendMultipart(request);
      var responseBody = await response.stream.bytesToString();
      return _handleResponse(http.Response(responseBody, response.statusCode));
    } on SocketException catch (e) {
      throw ApiError.generic();
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (kDebugMode) print(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      throw ApiError.generic();
    } else {
      try {
        throw ApiError.fromJson(jsonDecode(response.body));
      } catch (e) {
        if(e is ApiError) rethrow;
        throw ApiError.generic();
      }
    }
  }
}
