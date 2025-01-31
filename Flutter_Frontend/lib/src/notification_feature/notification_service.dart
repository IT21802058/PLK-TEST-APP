import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../common/constants.dart';
import 'notification_model.dart';

class NotificationService {
  final baseUrl = dotenv.env[Constants.baseURL];

  Future<bool> notify(PushNotification notification) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/notify'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(notification.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
        return true;
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
}
