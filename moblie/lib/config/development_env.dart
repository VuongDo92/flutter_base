import './env.dart';

class DevelopmentEnv extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  static DevelopmentEnv value;

  @override
  String appName = "Flutter-Base";

  @override
  String apiBaseUrl = 'https://ocspstage.globe.com.ph/';

  @override
  String apiBaseUrlConfig = 'https://wwwstage.globe.com.ph/';

  DevelopmentEnv() {
    value = this;
  }
}
