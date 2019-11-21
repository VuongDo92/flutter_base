import './env.dart';

class ProductionEnv extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  static ProductionEnv value;

  @override
  String appName = "Flutter-Base";

  @override
  String apiBaseUrl = 'https://ocspstage.globe.com.ph';

  @override
  String apiBaseUrlConfig = 'https://wwwstage.globe.com.ph/';

  ProductionEnv() {
    value = this;
  }
}
