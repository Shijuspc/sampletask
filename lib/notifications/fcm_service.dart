import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New Notification: ${message.notification?.title}");
    });
  }
}
