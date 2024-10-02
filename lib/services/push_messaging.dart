import 'package:firebase_messaging/firebase_messaging.dart';

/// Annotated as entry point to prevent being tree-shaken in release mode.
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  print(
      "RemoteMessagingService: Received a data message in the background: ${message.data.toString()}");

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
}

class PushMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Request permission for receiving push notifications. Returns a device token that can be used to target this device if user granted permission.
  Future<String?> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      // User denied permission
      return null;
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'RemoteMessagingService: Received a message in the foreground: ${message.data.toString()}');
      // Process the message here
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'RemoteMessagingService: Opened a notification message: ${message.data.toString()}');
      // Process the open event here
    });
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    return await _firebaseMessaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
