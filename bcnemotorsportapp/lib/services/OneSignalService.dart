import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static final OneSignal _oneSignal = OneSignal.shared;
  static const String oneSignalAppId = "7586c645-2c69-4511-8f76-2e2dc480a963";
  
  
  

  // ###### FUNCTIONS TO CALL OUTSIDE THIS ######

  static Future<void> homeInitialization() async {
    await _oneSignal.setAppId(oneSignalAppId);
    _oneSignal.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notifications is received in foreground
      final notification = event.notification;
      print(notification.title);
      print(notification.body);
      print(notification.additionalData);
      event.complete(notification);
    });
    
    _oneSignal.setNotificationOpenedHandler((OSNotificationOpenedResult openedResult) {
      final notification = openedResult.notification;
      print(notification.title);
      print(notification.body);
      print(notification.additionalData);
    });
  }

}