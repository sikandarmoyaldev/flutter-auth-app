import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String _baseUrl = 'http://127.0.0.1:3000/api/auth';

  static const _storage = FlutterSecureStorage();

  static const _keyAccessToken = 'auth:access_token';
  static const _keyRefreshToken = 'auth:refresh_token';
  static const _keyUserId = 'user:id';
  static const _keyUserName = 'user:name';
  static const _keyUserEmail = 'user:email';

  static Future<Map<String, String>?> getUser() async {
    final values = await Future.wait([
      _storage.read(key: _keyUserId),
      _storage.read(key: _keyUserName),
      _storage.read(key: _keyUserEmail),
    ]);

    final userId = values[0];
    final userName = values[1];
    final userEmail = values[2];

    if (userId == null || userName == null || userEmail == null) {
      debugPrint(
        'getUser: incomplete data — userId: $userId, name: $userName, email: $userEmail',
      );
      return null;
    }

    debugPrint('getUser: retrieved user — $userName ($userEmail)');

    // Return typed map for safe access: user?['name']
    return {'id': userId, 'name': userName, 'email': userEmail};
  }

  static Future<bool> isAuthenticated() async {
    final accessToken = await _storage.read(key: _keyAccessToken);
    return accessToken != null && accessToken.isNotEmpty;
  }

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

        final data = result['data'];

        final accessToken = data['tokens']['accessToken'] as String;
        final refreshToken = data['tokens']['refreshToken'] as String;
        final user = data['user'] as Map<String, dynamic>;

        await _saveAuthData(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: user['id'] as String,
          userName: user['name'] as String,
          userEmail: user['email'] as String,
        );
      }

      return result;
    } catch (e) {
      debugPrint('Login error: $e');
      return {'success': false, 'error': 'Network error: $e'};
    }
  }

  static Future<void> logout() async {
    debugPrint('Logging out: clearing auth data...');

    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyUserId),
      _storage.delete(key: _keyUserName),
      _storage.delete(key: _keyUserEmail),
    ]);

    debugPrint('Auth data cleared successfully');
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

      final result = _handleResponse(response);

      if (result['success']) {
        final data = result['data'];
        final accessToken = data['tokens']['accessToken'] as String;
        final refreshToken = data['tokens']['refreshToken'] as String;
        final user = data['user'] as Map<String, dynamic>;

        await _saveAuthData(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userId: user['id'] as String,
          userName: user['name'] as String,
          userEmail: user['email'] as String,
        );
        debugPrint('Auth data saved securely');
      }

      return result;
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

  static Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String userName,
    required String userEmail,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyUserId, value: userId),
      _storage.write(key: _keyUserName, value: userName),
      _storage.write(key: _keyUserEmail, value: userEmail),
    ]);
  }
}
