import 'dart:async';
import 'dart:isolate';

import 'package:bittrex_app/app.dart';
import 'package:bittrex_app/provider/dio_api_provider.dart';
import 'package:bittrex_app/provider/dio_remote_api_provider.dart';
import 'package:bittrex_app/provider/mobile_provider.dart';
import 'package:core/stores/akamai_store.dart';

import 'package:core/repositories/providers/providers.dart';
import 'package:core/repositories/authenticate_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

kiwi.Container container = kiwi.Container();

enum EnvType {
  DEVELOPMENT,
  PRODUCTION,
}

abstract class Env {
  EnvType environmentType = EnvType.DEVELOPMENT;

  /// pref to dio_remote_api_provider
  String apiBaseUrlConfig = 'https://wwwstage.globe.com.ph/';

  ApiProvider apiProvider;

  RemoteApiProvider remoteApiProvider;

  String appName = 'Rovo';
  String baseUrl;
  String host;

  // API
  String apiBaseUrl;

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

    AuthenticateRepository accountRepository = container.resolve<AuthenticateRepository>();
    await accountRepository.init();

    // todo implement localization
//    final locale = container.resolve<LocalStorageProvider>().getString('locale');
//
//    String localeString =  locale as String ?? 'en';

    AkamaiStore akamaiStore = AkamaiStore(authenticateRepository: accountRepository);

    // Set up error hooks and run app
    final app = App(
      env: this,
      akamaiStore: akamaiStore,
      locale: Locale('en'),
    );

    if(remoteApiProvider is DioRemoteApiProvider) {
      remoteApiProvider.registerApp(app);
    }
    if(apiProvider is DioApiProvider) {
      apiProvider.registerApp(app);
    }

    bool isInDebugMode = false;
    assert(() {
      isInDebugMode = true;
      return true;
    }());
    // todo first init & config Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (isInDebugMode) {
        // In development mode simply print to console.
        FlutterError.dumpErrorToConsole(details);
      }
      if (details.stack != null) {
        debugPrint(details.toString());
      }
    };
    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      final isolateError = pair as List<dynamic>;
      await app.onError(
        isolateError.first.toString(),
        stack: isolateError.last.toString(),
      );
    }).sendPort);

    /// Disabling red screen of death in release mode
    if (!isInDebugMode) {
      ErrorWidget.builder = (FlutterErrorDetails details) => Container();
    }
    // Run app
    return runZoned(() async {
      runApp(app);
    }, onError: (error, stackTrace) async {
      app.onError(error, stack: stackTrace);
    });
  }

  void _registerProviders() async {

    container.registerSingleton<RemoteApiProvider, DioRemoteApiProvider>(
            (c) => DioRemoteApiProvider(apiBaseUrlConfig));

    container.registerSingleton<ApiProvider, DioApiProvider>(
        (c) => DioApiProvider(apiBaseUrl));
  
    container.registerSingleton<SecretProvider, SecureStorageProvider>(
        (c) => SecureStorageProvider());

    container.registerSingleton<LocalStorageProvider, MobileStorageProvider>(
        (c) => MobileStorageProvider());
    
    container.registerSingleton<RemoteConfigProvider, MobileConfigProvider>((c) => MobileConfigProvider());

  }

  void _registerRepositories() {
    final apiRemoteProvider = container.resolve<RemoteApiProvider>();
    final apiProvider = container.resolve<ApiProvider>();
    final secretProvider = container.resolve<SecretProvider>();
    final localStorageProvider = container.resolve<LocalStorageProvider>();

    final AuthenticateRepository authenticateRepo = AuthenticateRepository(apiRemoteProvider, apiProvider, secretProvider, localStorageProvider);

    container.registerSingleton((c) => authenticateRepo);
  }
}

