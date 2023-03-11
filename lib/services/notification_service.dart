import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

 /* void requestPermission() async {
    NotificationServices settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }*/

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
