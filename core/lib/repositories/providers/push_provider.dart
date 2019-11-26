typedef bool NotificationActionHandler(Map<String, dynamic> notifiication);

abstract class PushProvider {
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

  void showLocalNotificationIos({String title, String message, String link});
}
