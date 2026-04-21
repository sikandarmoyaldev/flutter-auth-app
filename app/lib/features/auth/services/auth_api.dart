import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'http://127.0.0.1:3000/api/auth';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Login request to: $_baseUrl/login');
      debugPrint('Email: $email');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      final result = _handleResponse(response);

      if (result['success']) {
        debugPrint('${result['token']}');
      }

      return result;
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('Register request to: $_baseUrl/register');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Response status: ${response.statusCode}');
      debugPrint(' Response body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Register error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data};
    }

    // Extract backend error message
    final message = data['error'] ?? 'Something went wrong';
    return {'success': false, 'error': message, 'details': data['details']};
  }
}
