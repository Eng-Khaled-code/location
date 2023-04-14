import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/PL/global/firebase_var_ref/backup_ref.dart';
import 'package:location/PL/global/firebase_var_ref/notify_ref.dart';

import '../../PL/global/global_variables/global_variables.dart';

class SendPushNotificationServices {
  Future<void> sendPushNotification(
      String token, Map<String, dynamic> notifyData) async {
    try {
      final postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

      Map<String, dynamic> data = {
        "to": token,
        "priority": "high",
        "data": <String, dynamic>{
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "title": notifyData[NotifyRef.fromName],
          "body": notifyData[NotifyRef.content],
          BackupRef.backupIdRef: notifyData[NotifyRef.contentId],
          NotifyRef.type: notifyData[NotifyRef.type]
        },
        "notification": {
          "title": notifyData[NotifyRef.fromName],
          "body": notifyData[NotifyRef.content],
          "android_channel_id": "location_channel"
        }
      };

      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization': GlobalVariables.fireaseMessagingServerKey
      };

      final response = await http.post(postUrl,
          body: json.encode(data),
          encoding: Encoding.getByName('utf-8'),
          headers: headers);

      if (response.statusCode == 200) {
        print("success");
      }
    } catch (e) {
      print(e);
    }
  }
}
