import 'dart:convert';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BatteryApi {
  static const String _baseUrl = 'http://127.0.0.1:3000/api';

  static Future<bool> sendBatteryToBackend() async {
    try {
      final battery = Battery();
      final level = await battery.batteryLevel;
      final state = await battery.batteryState;

      final response = await http
          .post(
            Uri.parse('$_baseUrl/battery'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'batteryLevel': level,
              'isCharging': state == BatteryState.charging,
              'timestamp': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 5)); // 5s timeout

      debugPrint('Response: $response');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Battery send error: $e');
      return false;
    }
  }
}
