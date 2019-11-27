
typedef Future<dynamic> NotificationBackgroundMessage(Map<String, dynamic> message);

abstract class PushProvider {

  NotificationBackgroundMessage notificationBackgroundMessage;

  String pushToken;

  Future init();

  void requestNotificationPermission();

  Future handleNotification({
    String type,
    String title,
    String body,
    String link,
    String clickAction,
    Map<String, dynamic> data,
  });

  void clearNotificationMessages(String type, String key,
      {bool clearNotification});
}
