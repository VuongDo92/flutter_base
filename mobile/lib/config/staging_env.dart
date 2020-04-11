import './env.dart';

class StagingEnv extends Env {
  EnvType environmentType = EnvType.STAGING;
  static StagingEnv value;

  @override
  String appName = "Flutter-Base";

  @override
  String apiBaseUrl = 'https://ocspstage.globe.com.ph/';

  @override
  String apiBaseUrlConfig = 'https://wwwstage.globe.com.ph/';

  StagingEnv() {
    value = this;
  }
}
