import 'dart:convert';

import 'package:bcnemotorsportapp/models/utilsAndErrors.dart';
import 'package:bcnemotorsportapp/providers/CloudDataProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class MessagingService {
  static const String _firebaseServerKey =
      'AAAAYCqw6vs:APA91bEkxsSTSCFDn9pFSHSe5ughKiDSTYr8Oy0pZLWF2TM8RgZcbegnMeF9NuW-EtKXUPgh0TfHtN1z3oxbyYiRDMakAhpwQX0jJ1ORzwTgSYKBgfC-LW7Et807OQAcKTLZNaPrgaMF';

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _highChannel = AndroidNotificationChannel(
    "high_importance_channel",
    "High Importance Notifications",
    "This channel is used for important notifications.",
    importance: Importance.max,
  );

  static Future<String> getToken() async => await FirebaseMessaging.instance.getToken();

  // ###### HANDLERS ######

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message: ${message.messageId}');
  }

  static void _userTapsOnNotificationHandler(RemoteMessage message, BuildContext context) {
    print("user tap on notification");
  }

  // ###### FUNCTIONS TO CALL OUTSIDE THIS ######

  static Future<void> mainInitialization() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_highChannel);
  }

  static void homeInitialization(BuildContext context, List<String> memberSectionIds) {
    var initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    // What happens when app is terminated and user taps on notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      print("???????getInitialMessage");
      if (message != null) {
        _userTapsOnNotificationHandler(message, context);
      }
    });

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Foreground notifications, called immediately when the notification arrives
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("??????????onMessage");
      print(message.data);
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _highChannel.id,
                _highChannel.name,
                _highChannel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });

    // Background notification (not app terminated), called immediately when the user taps
    // Not called when app is in foreground and user taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("???????????onMessageOpenedApp");
      _userTapsOnNotificationHandler(message, context);
    });

    // Subscribe to topics
    FirebaseMessaging.instance.subscribeToTopic('global');
    memberSectionIds.forEach((topic) {
      FirebaseMessaging.instance.subscribeToTopic(topic);
    });
  }

  static Future<void> postNotification(
    BuildContext context, {
    @required String title,
    @required String body,
    String topic,
    List<String> destTokens,
    Map data,
  }) async {
    assert(topic != null || (destTokens != null && destTokens.isNotEmpty),
        "When sending a notification, either topic or desTokens must have content.");
    
    if (topic != null) await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    Response response = await post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_firebaseServerKey'
      },
      body: jsonEncode({
        'notification': <String, dynamic>{
          'title': title,
          'body': body,
          'sound': 'true',
          'click_action': "FLUTTER_NOTIFICATION_CLICK",
        },
        'android_channel_id': _highChannel.id,
        'priority': 'high',
        if (topic != null) 'to': '/topics/' + topic,
        if (destTokens != null) 'registration_ids': destTokens,
        'data': data,
        //'condition': "'perception' in topics",
      }),
    );
    if (topic != null) await FirebaseMessaging.instance.subscribeToTopic(topic);
    if (response.statusCode < 200 || response.statusCode > 299)
      Popup.errorPopup(context, response.reasonPhrase);
  }
}
