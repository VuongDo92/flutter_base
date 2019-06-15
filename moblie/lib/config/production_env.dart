import './env.dart';

class ProductionEnv extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  static ProductionEnv value;

  String appName = 'Rovo';
  String baseUrl = 'https://rovo.co';
  String host = 'rovo.co';

  String apiBaseUrl = 'https://api.rovo.co';
  String apiVersion = 'v1.9.0';

  // Database Config
  int dbVersion = 1;
  String dbName = 'rovo.db';
  String amplitudeApiKey = 'fillme';
  String stripeApiKey = 'fillme';

  ProductionEnv() {
    value = this;
  }
}
