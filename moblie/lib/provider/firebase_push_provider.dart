import 'dart:io';
import 'dart:isolate';
import 'dart:isolate';

import 'package:core/repositories/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_version/get_version.dart';

import '../app.dart';



class FirebasePushProvider implements PushProvider {

  FlutterLocalNotificationsPlugin notificationsPlugin;

  String pushToken;
  FirebaseMessaging _firebaseMessaging;
  NotificationBackgroundMessage notificationBackgroundMessage;

  @override
  void clearNotificationMessages(String type, String key,
      {bool clearNotification}) {
    if (clearNotification) {
      FlutterLocalNotificationsPlugin().cancel(key.hashCode);
    }
  }

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  Future<void> init() async {
    _initLocalPushNotification();

    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      debugPrint('onMessage');
      debugPrint(':::tag::: onMessage $message');

//      Map<String, dynamic> _data = message['data'];
      String _title = message['data']['title'];
      String _body = message['data']['body'];
      String _clickAction = message['data']['click_action'];

//      debugPrint("data: $_data");
      debugPrint("title: $_title");
      debugPrint("body: $_body");
      debugPrint("click_action: $_clickAction");

      AndroidNotificationStyle notificationStyle =
          AndroidNotificationStyle.Default;
      Importance importance = Importance.Max;
      Priority priority = Priority.High;
//      StyleInformation styleInformation;
      String channelId = await GetVersion.appID;
      String channelTitle = 'Others';
      String channelDescript = 'Another';
      String ticker = 'ticker';

      if(notificationsPlugin == null) {
        notificationsPlugin =
            FlutterLocalNotificationsPlugin();
      }
      /// init setting for android
      var initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

      /// init setting for ios
      var initializationSettingsIOS = new IOSInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

      /// init setting for both
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);

      /// init local-push for both
      notificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);

      /// build a notification detail for android
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channelId, channelTitle, channelDescript,
          importance: importance,
          priority: priority,
          ticker: ticker,
          style: notificationStyle);

      /// build a notification detail for ios
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();

      /// build a notification detail for both
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      /// show notification
      final appName = await GetVersion.appName;
      await notificationsPlugin.show(
        0,
        _title ==null || _title.isEmpty ? appName : _title,
        _body,
        platformChannelSpecifics,
        payload: "item x",
      );
      print("after handle-notification");

    }, onBackgroundMessage: Platform.isIOS ? null : notificationBackgroundMessage,
        onLaunch: (Map<String, dynamic> message) async {
      debugPrint('onLaunch');
    }, onResume: (Map<String, dynamic> message) async {
      debugPrint('onResume');
    });

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) async {
      debugPrint("Settings registered: $settings");
      pushToken = await _firebaseMessaging.getToken();
      print("Push Messaging token: $pushToken");
    });

    pushToken = await _firebaseMessaging.getToken();
    print("Push Messaging token: $pushToken");
  }

  void _initLocalPushNotification() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future<void> onSelectNotification(String payload) async {}

  @override
  Future handleNotification(
      {String type,
      String title,
      String body,
      String link,
      String clickAction,
      Map<String, dynamic> data}) async {
    AndroidNotificationStyle notificationStyle =
        AndroidNotificationStyle.Default;
    Importance importance = Importance.Default;
    Priority priority = Priority.Default;
    StyleInformation styleInformation;
    String channelId = await GetVersion.appID;
    String channelTitle = 'Others';

    if(notificationsPlugin == null) {
      notificationsPlugin =
          FlutterLocalNotificationsPlugin();
    }
    /// init setting for android
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    /// init setting for ios
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    /// init setting for both
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    /// init local-push for both
    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    /// build a notification detail for android
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelTitle, null,
        importance: importance,
        priority: priority,
        style: notificationStyle,
        styleInformation: styleInformation);

    /// build a notification detail for ios
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    /// build a notification detail for both
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    /// show notification
    final appName = await GetVersion.appName;
    await notificationsPlugin.show(
      0,
      title == null || title.isEmpty ? appName : title,
      body,
      platformChannelSpecifics,
      payload: "item x",
    );
  }
}
