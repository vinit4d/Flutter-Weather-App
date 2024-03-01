import 'dart:convert';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../exceptions/exception_handler.dart';
import '../exceptions/remote_data_source_exception.dart';


final _indent = ' ' * 11;

void _logRequest(
    Uri url,
    String method, {
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      Map<String, String>? multipartFields,
      List<http.MultipartFile>? multipartFiles,
    }) {
  debugPrint('[http] --> $method $url');
  debugPrint('${_indent}headers: $headers');

  if (method == 'POST' || method == 'PUT') {
    debugPrint('${_indent}body: ${jsonEncode(body)}');

    if (method == 'POST') {
      if (multipartFields != null) {
        debugPrint('${_indent}multipartFields: $multipartFields');
      }
      // if (multipartFields != null) {
      //   debugPrint('${_indent}multipartFiles: $multipartFiles');
      // }
    }
  }
}

void _logResponse(http.Response response) {
  debugPrint('[http] <-- ${response.statusCode} ${response.request}');
  debugPrint('${_indent}bodyBytes: ${response.bodyBytes.length}');
  try {
    debugPrint('${_indent}body: ${jsonEncode(response.body)}');
  } catch (_) {}
}

class NetworkUtils {
  static Future _helper(
      String method,
      Uri url, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) async {
    _logRequest(url, method, headers: headers, body: body);

    final request = http.Request(method, url);
    if (body != null) {
      List<int> bodyBytes = utf8.encode(json.encode(body));
      request.bodyBytes = bodyBytes;
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    _logResponse(response);
    return _parse(response);
  }

  static dynamic _parse(http.Response response) {
    final body = response.body;
    final statusCode = response.statusCode;

    final decoded = json.decode(body);
    if (isValidStatus(response)) {
      return decoded;
    } else {
      throw RemoteDataSourceException(statusCode, decoded['errors'].toString());
    }
  }

  static bool isValidStatus(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return true;
      case 201:
        return true;
      case 204:
        throw NotFoundException(jsonDecode(response.body)['message']);
      case 400: //Bad request
        throw BadRequestException(jsonDecode(response.body)['message']);
      case 401: //Unauthorized
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 403: //Forbidden
        throw UnAuthorizedException(jsonDecode(response.body)['message']);
      case 404: //Resource Not Found
        if (jsonDecode(response.body)['message'].toString().contains("email")) {
          throw NotFoundException(
              jsonDecode(response.body)['message']['email'][0]);
        } else if (jsonDecode(response.body)['message']
            .toString()
            .contains("password")) {
          throw NotFoundException(
              jsonDecode(response.body)['message']['password'][0]);
        } else {
          throw NotFoundException(jsonDecode(response.body)['message']);
        }

      case 409:
        throw
        ValidationException(jsonDecode(response.body)['error']);
      case 422:
        throw ValidationException(jsonDecode(response.body)['error']);
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
            'Something went wrong! ${response.statusCode}');
    }
  }

  ///
  ///
  /// ========================= HTTP REQUESTS ======================
  ///
  ///
  static Future get(
      Uri url, {
        Map<String, String>? headers,
      }) async {
    _logRequest(url, 'GET', headers: headers);

    final response = await http.get(url, headers: headers);
    _logResponse(response);
    return _parse(response);
  }

  static Future post(
      Uri url, {
        Map<String, String>? headers,
        Map<String, dynamic>? body,
      }) =>
      _helper(
        'POST',
        url,
        headers: headers,
        body: body,
      );

  static Future patch(
      Uri url, {
        Map<String, String>? headers,
        dynamic body,
      }) =>
      _helperList(
        'PATCH',
        url,
        headers: headers,
        body: body,
      );


  static Future postImage(
      Uri url, {
        Map<String, String>? headers,
        required File file,
      }) =>
      _helperUploadImage("POST", url, file: file, headers: headers);

  static Future _helperList(
      String method,
      Uri url, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    _logRequest(url, method, headers: headers);

    final request = http.Request(method, url);
    if (body != null) {
      List<int> bodyBytes = utf8.encode(json.encode(body));
      request.bodyBytes = bodyBytes;
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    _logResponse(response);
    return _parse(response);
  }

  static Future _helperUploadImage(
      String method,
      Uri url, {
        Map<String, String>? headers,
        required File file,
      }) async {
    _logRequest(url, method, headers: headers, body: {"file": file.path});

    var request = http.MultipartRequest(method, url);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    if (headers != null) {
      request.headers.addAll(headers);
    }
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    _logResponse(response);
    return _parse(response);
  }
}
