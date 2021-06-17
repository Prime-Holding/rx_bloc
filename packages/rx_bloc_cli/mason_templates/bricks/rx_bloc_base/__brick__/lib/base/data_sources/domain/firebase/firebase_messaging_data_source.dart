import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingDataSource {
  final _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessaging get instance => _firebaseMessaging;

  // Checks if the user has granted permissions for displaying push messages.
  // If called the very first time, the user is asked to grant permissions.
  Future<bool> requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission();
    return settings.authorizationStatus != AuthorizationStatus.denied;
  }
}
