import 'dart:async';
import 'dart:isolate';

import 'package:bittrex_app/app.dart';
import 'package:bittrex_app/provider/dio_api_provider.dart';
import 'package:bittrex_app/provider/mobile_provider.dart';

import 'package:core/repositories/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

kiwi.Container container = kiwi.Container();

enum EnvType {
  DEVELOPMENT,
  PRODUCTION,
}

abstract class Env {
  EnvType environmentType = EnvType.DEVELOPMENT;

  String appName = 'Rovo';
  String baseUrl;
  String host;

  // API
  String apiBaseUrl;
  String apiVersion;

  String get apiUrl => '$apiBaseUrl/$apiVersion';

  // Database Config
  int dbVersion = 1;
  String dbName = 'rovo-dev.db';

  // Third party api keys
  String amplitudeApiKey;
  String stripeApiKey;
  String googleMapApiKey;

  String deeplinkScheme;
  List<String> rovoDomains;

  Env() {
    _init();
  }

  Future _init() async {
    _registerProviders();
    _registerRepositories();

    final all = await Future.wait([
      container.resolve<RemoteConfigProvider>().init(),
      container.resolve<LocalStorageProvider>().getString('locale'),
    ]);

//    container.resolve<PushProvider>().init();

    String localeString =  all.last as String ?? 'en';

//    AccountStore accountStore = AccountStore(
//      accountRepository: container.resolve<AccountRepository>(),
//    );

    // Example of analytics
//    AmplitudeAnalytics amplitude = AmplitudeAnalytics(amplitudeApiKey);
//    Analytics.register(amplitude);
    // Set up error hooks and run app
    final app = App(
//      accountStore: accountStore,
      env: this,
      locale: localeString != null ? Locale(localeString) : null,
    );

    bool isInDebugMode = false;
    assert(() {
      isInDebugMode = true;
      return true;
    }());
//    Crashlytics.instance.enableInDevMode = true;
//    FlutterError.onError = (FlutterErrorDetails details) async {
//      if (isInDebugMode) {
//        // In development mode simply print to console.
//        FlutterError.dumpErrorToConsole(details);
//      }
//      Crashlytics.instance.onError(details);
//    };
    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      await app.onError(
        isolateError.first.toString(),
        stack: isolateError.last.toString(),
      );
    }).sendPort);

    // Run app
    return runZoned(() async {
      runApp(app);
    }, onError: (error, stackTrace) async {
      app.onError(error, stack: stackTrace);
    });
  }

  void _registerProviders() async {

    container.registerSingleton<ApiProvider, DioApiProvider>(
        (c) => DioApiProvider(apiBaseUrl + '/' + apiVersion));
  
    container.registerSingleton<SecretProvider, SecureStorageProvider>(
        (c) => SecureStorageProvider());

    container.registerSingleton<LocalStorageProvider, MobileStorageProvider>(
        (c) => MobileStorageProvider());
    
    container.registerSingleton<RemoteConfigProvider, MobileConfigProvider>((c) => MobileConfigProvider());

  }

  void _registerRepositories() {
    final apiProvider = container.resolve<ApiProvider>();
    final secretProvider = container.resolve<SecretProvider>();
    final localStorageProvider = container.resolve<LocalStorageProvider>();
    final remoteConfigProvider = container.resolve<RemoteConfigProvider>();

  }
}

