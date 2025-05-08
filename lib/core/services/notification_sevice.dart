import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
  static const String _serverKey = 'YOUR_SERVER_KEY';
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  Future<void> sendNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse(_fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
      body: json.encode({
        'to': '/topics/$topic',
        'notification': {
          'title': title,
          'body': body,
        },
        'priority': 'high',
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }
  }
}
