abstract class PushProvider {
  String pushToken;

  Future init();
  Future handleNotification({
    String type,
    String title,
    String body,
    String link,
    String clickAction,
    Map<String, dynamic> data,
  });

  void showLocalNotificationIos({String title, String message, String link});
}
