import './env.dart';

class DevelopmentEnv extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  static DevelopmentEnv value;
  @override
  String appName = 'Rovo';
  @override
  String baseUrl = 'https://inrovo.co';
  @override
  String host = 'inrovo.co';
  @override
  String apiBaseUrl = 'https://api.inrovo.co';
  @override
  String apiVersion = 'v1.9.0';
  @override
  int dbVersion = 1;
  @override
  String dbName = 'rovo-dev.db';
  @override
  String amplitudeApiKey = 'd2a56dd52f7f0178247ca8de0991f152';
  @override
  String stripeApiKey = 'pk_test_d1i8P8z8WoENK9lCqBEAaW7r';
  @override
  String googleMapApiKey = 'AIzaSyDfQOB_yXnssEgzGQGxaez_UKrRcm5NFW4';
  @override
  String deeplinkScheme = 'rovo';
  @override
  List<String> rovoDomains = ['inrovo.co'];

  DevelopmentEnv() {
    value = this;
  }
}
