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
      final response = await http.post(
        _buildUrl(endpoint),
        headers: await _headers(extra: headers),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      return _error(e);
    }
  }

  static Future<Map<String, dynamic>> getRequest(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        _buildUrl(endpoint),
        headers: await _headers(extra: headers),
      );
      return _processResponse(response);
    } catch (e) {
      return _error(e);
    }
  }

  static Future<Map<String, dynamic>> putRequest(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.put(
        _buildUrl(endpoint),
        headers: await _headers(extra: headers),
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      return _error(e);
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
      final response = await http.Response.fromStream(await request.send());
      return _processResponse(response);
    } catch (e) {
      return _error(e);
    }
  }

  // static Map<String, dynamic> _processResponse(http.Response response) {
  //   try {
  //     return jsonDecode(response.body);
  //   } catch (_) {
  //     return {
  //       'status': '0',
  //       'message': 'Invalid response format',
  //       'raw': response.body,
  //     };
  //   }
  // }
  static Map<String, dynamic> _processResponse(http.Response response) {
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
      return jsonDecode(response.body);
    } catch (_) {
      return {
        'status': '0',
        'message': 'Invalid response format',
        'raw': response.body,
      };
    }
  }

  static Map<String, dynamic> _error(dynamic e) {
    return {
      'status': '0',
      'message': 'Something went wrong',
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
