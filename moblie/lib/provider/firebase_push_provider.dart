import 'package:core/repositories/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebasePushProvider implements PushProvider {
  NotificationActionHandler _notificationActionHandler;
  Map<String, dynamic> _onLaunchMessage;
  NotificationActionHandler get notificationActionHandler =>
      _notificationActionHandler;

  set notificationActionHandler(NotificationActionHandler handler) {
    _notificationActionHandler = handler;
    if (_onLaunchMessage != null) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        handler(_onLaunchMessage);
      });
    }
  }

  @override
  String pushToken;

  FirebaseMessaging _firebaseMessaging;

  @override
  void clearNotificationMessages(String type, String key,
      {bool clearNotification}) {
    if (clearNotification) {
      FlutterLocalNotificationsPlugin().cancel(key.hashCode);
    }
  }

  @override
  Future handleNotification(
      {String type,
      String title,
      String body,
      String link,
      String clickAction,
      Map<String, dynamic> data}) {
    // TODO: implement handleNotification
    return null;
  }

  // TODO: handle message when app background & app terminal
  @override
  Future<void> init() async {
    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      debugPrint('onMessage');
    }, onLaunch: (Map<String, dynamic> message) async {
      debugPrint('onLaunch');
    });

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) async {
      debugPrint("Settings registered: $settings");
      pushToken = await _firebaseMessaging.getToken();
    });

    pushToken = await _firebaseMessaging.getToken();
  }

  @override
  void requestNotificationPermission() {
    final iosNotificationSettings = const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    );
    _firebaseMessaging.requestNotificationPermissions(iosNotificationSettings);
  }

  @override
  void showLocalNotificationIos({String title, String message, String link}) {
    // TODO: implement showLocalNotificationIos
  }
}
