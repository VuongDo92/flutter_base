import 'dart:io';

import 'package:core/repositories/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
/// Signature of callback passed to [initialize]. Callback triggered when user taps on a notification
typedef SelectNotificationCallback = Future<dynamic> Function(String payload);

// Signature of the callback that is triggered when a notification is shown whilst the app is in the foreground. Applicable to iOS versions < 10 only
typedef DidReceiveLocalNotificationCallback = Future<dynamic> Function(
    int id, String title, String body, String payload);

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<void> onSelectNotification(String payload) async {}


* */

class FirebasePushProvider implements PushProvider {

  FlutterLocalNotificationsPlugin localPushPlugin;

  String pushToken;
  FirebaseMessaging _firebaseMessaging;
  NotificationMessageCallback backgroundMessage;
  NotificationMessageCallback foregroundMessage;

  /// for android
  SelectNotificationCallback onSelectNotification;

  /// for ios
  DidReceiveLocalNotificationCallback onDidReceiveLocalNotification;

  @override
  void clearNotificationMessages(String type, String key,
      {bool clearNotification}) {
    if (clearNotification) {
      FlutterLocalNotificationsPlugin().cancel(key.hashCode);
    }
  }

  @override
  Future<void> setConfigure() async {
    if(_firebaseMessaging == null) {
      return;
    }
    _firebaseMessaging.configure(
      onMessage: foregroundMessage,
      onLaunch: foregroundMessage,
      onResume: foregroundMessage,
      onBackgroundMessage: Platform.isIOS ? null : backgroundMessage
    );
  }

  @override
  Future<void> init() async {

    /// init local-push-plugin
    localPushPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    localPushPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    /// init firebase-message plugin
    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) async {
      debugPrint("Settings registered: $settings");
      pushToken = await _firebaseMessaging.getToken();
      print("Push Messaging token: $pushToken");
    });

    pushToken = await _firebaseMessaging.getToken();
    print("Push Messaging token: $pushToken");
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
}
