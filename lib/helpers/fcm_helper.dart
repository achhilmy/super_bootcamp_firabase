import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_superbootcamp/helpers/notification_helper.dart';
import 'package:flutter/foundation.dart';

class FcmHelper {
  Future<void> init() async {
    await FirebaseMessaging.instance.getToken();

    final fcmToken = await FirebaseMessaging.instance.getToken();

    print("FCM Token:$fcmToken ");

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      NotificationHelper.payload.value = jsonEncode({
        "title": value?.notification?.body,
        "body": value?.notification?.body,
        "data": value?.data
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((value) {
      NotificationHelper.payload.value = jsonEncode({
        "title": value.notification?.body,
        "body": value.notification?.body,
        "data": value.data
      });
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null && !kIsWeb) {
        await NotificationHelper.flutterLocalNotificationsPlugin.show(
          Random().nextInt(99),
          notification.title,
          notification.body,
          payload: jsonEncode(
            {
              "title": notification.body,
              "body": notification.body,
              "data": message.data
            },
          ),
          NotificationHelper.notificationDetails,
        );
      }
    });
  }

  static Map<String, dynamic> tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return {};
    }
  }
}
