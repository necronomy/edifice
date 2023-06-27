import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;

class SendMsg {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAAfo-aKxM:APA91bHRsHvPu8MsPJaTjAvdVdHQCFm0-3yhzJX19bdHBVowBV_FmCCEqdMgAybAZuhD6TeoGOcvP5akihi5WTkPEBFbVTio2Xc6Fj9EivWwC0uPhf7ynsLMj1EpoxbZAsNPJBiK92h6'
  };
  Future<http.Response> sendMessage(String title, String body, String topic) async {
    String toParams = "/topics/$topic";
    final data = {
      "notification": {
        "body": body,
        "title": title,
        "sound": 'default',
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": body,
      },
      "to": toParams
    };
    final response = await http.post(Uri.parse(postUrl), body: json.encode(data), encoding: Encoding.getByName('utf-8'), headers: headers);
    return response;
  }

  Future<void> sendNotification(topic, {String? title, String? body, String? imageUrl}) async {
    FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'us-central1');

    try {
      final HttpsCallable callable = functions.httpsCallable('sendNotification');
      final response = await callable.call({
        'topic': topic,
        'title': title,
        'body': body,
      });

      print('Message sent: ${response.data}');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}

class SaveSavdo {}
