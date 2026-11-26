import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../storage/session_store.dart';

class ApiResponse {
  const ApiResponse({required this.statusCode, this.data, this.message});

  final int statusCode;
  final dynamic data;
  final String? message;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  String get errorMessage => (message != null && message!.isNotEmpty)
      ? message!
      : 'Something went wrong. Please try again.';
}

class ApiClient {
  ApiClient._();

  static const Duration _timeout = Duration(seconds: 60);

  /// Called when a request that carried a token comes back 401.
  static void Function()? onUnauthorized;

  static Future<ApiResponse> get(String url) => _send('GET', url);

  static Future<ApiResponse> post(String url, {Map<String, dynamic>? body}) =>
      _send('POST', url, body: body);

  static Future<ApiResponse> patch(String url, {Map<String, dynamic>? body}) =>
      _send('PATCH', url, body: body);

  static Future<ApiResponse> delete(String url) => _send('DELETE', url);

  static Future<ApiResponse> _send(
    String method,
    String url, {
    Map<String, dynamic>? body,
  }) async {
    final hadToken = SessionStore.hasToken;
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (hadToken) 'token': SessionStore.token!,
    };

    try {
      final request = http.Request(method, Uri.parse(url))
        ..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);

      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);

      dynamic decoded;
      if (response.body.isNotEmpty) {
        try {
          decoded = jsonDecode(response.body);
        } catch (_) {
          decoded = null;
        }
      }

      if (response.statusCode == 401 && hadToken) onUnauthorized?.call();

      return ApiResponse(
        statusCode: response.statusCode,
        data: decoded,
        message: _readMessage(decoded),
      );
    } on TimeoutException {
      return const ApiResponse(
        statusCode: -1,
        message: 'The server is taking too long to respond. Please try again.',
      );
    } on SocketException {
      return const ApiResponse(
        statusCode: -1,
        message: 'No internet connection. Check your network and retry.',
      );
    } catch (_) {
      return const ApiResponse(
        statusCode: -1,
        message: 'Unexpected error. Please try again.',
      );
    }
  }

  static String? _readMessage(dynamic body) {
    if (body is Map) {
      final value = body['message'] ?? body['error'] ?? body['msg'];
      if (value != null) return value.toString();
    }
    return null;
  }
}