
typedef Future<dynamic> NotificationMessageCallback(Map<String, dynamic> message);

abstract class PushProvider {

  NotificationMessageCallback backgroundMessage;
  NotificationMessageCallback foregroundMessage;

  String pushToken;

  Future init();

  Future setConfigure();

  void requestNotificationPermission();

  void clearNotificationMessages(String type, String key,
      {bool clearNotification});
}
