import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:human_heal/app/controllers/auth_controller.dart';
import 'package:human_heal/app/data/constants.dart';
import 'package:human_heal/app/routes/app_routes.dart';
import 'package:human_heal/app/services/user_storage.dart';

import 'token_storage.dart';

class ApiService {
  static Future<Map<String, String>> _headers({
    Map<String, String>? extra,
  }) async {
    final token = await TokenStorage.getToken();
    // 🔍 Print token for debugging
    print("[API Service] Token: ${token ?? 'No token'}");

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  static Uri _buildUrl(String endpoint) {
    return Uri.parse('${AppConstants.baseUrl}/$endpoint');
  }

  static Future<Map<String, dynamic>> postRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .post(
            _buildUrl(endpoint),
            headers: await _headers(extra: headers),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e) {
      return _error(e, endpoint: endpoint);
    }
  }

  static Future<Map<String, dynamic>> getRequest(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .get(_buildUrl(endpoint), headers: await _headers(extra: headers))
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e) {
      return _error(e, endpoint: endpoint);
    }
  }

  static Future<Map<String, dynamic>> putRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http
          .put(
            _buildUrl(endpoint),
            headers: await _headers(extra: headers),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e) {
      return _error(e, endpoint: endpoint);
    }
  }

  static Future<Map<String, dynamic>> deleteRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.Request("DELETE", _buildUrl(endpoint));
      request.headers.addAll(await _headers(extra: headers));
      if (body != null) request.body = jsonEncode(body);
      final streamed = await request.send().timeout(const Duration(seconds: 15));
      final response = await http.Response.fromStream(streamed);
      return _processResponse(response);
    } catch (e) {
      return _error(e, endpoint: endpoint);
    }
  }

  static Map<String, dynamic> _processResponse(http.Response response) {
    debugPrint("[API Service] Response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 401) {
      // 🔥 User unauthorized -> auto logout
      final authController = Get.put(AuthController());
      authController.handleUnauthorized();
      return {
        'status': '0',
        'message': 'Unauthorized. User logged out automatically.',
      };
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (response.statusCode >= 400) {
          decoded['status'] ??= '0';
        }
        return decoded;
      }
      return {
        'status': response.statusCode >= 400 ? '0' : '1',
        'data': decoded,
      };
    } catch (_) {
      return {
        'status': '0',
        'message': response.statusCode >= 400
            ? 'Server error (${response.statusCode})'
            : 'Invalid response format',
        'raw': response.body,
      };
    }
  }

  static Map<String, dynamic> _error(dynamic e, {String endpoint = ''}) {
    String message = 'Something went wrong';
    final errStr = e.toString().toLowerCase();

    if (errStr.contains('failed host lookup') ||
        errStr.contains('socketexception') ||
        errStr.contains('connection refused') ||
        errStr.contains('network is unreachable')) {
      message =
          'Server unreachable (${AppConstants.baseUrl}). Please verify internet connection or backend URL.';
    } else if (errStr.contains('timeoutexception') ||
        errStr.contains('timed out')) {
      message = 'Request to $endpoint timed out. Server is taking too long.';
    } else if (e is FormatException) {
      message = 'Invalid server response format.';
    }

    return {
      'status': '0',
      'message': message,
      'error': e.toString(),
    };
  }

  void handleUnauthorized() async {
    await TokenStorage.clearToken();
    await UserStorage.clearUser();

    Get.snackbar(
      "Session Expired",
      "Your account was removed or your session expired. Please log in again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );

    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
