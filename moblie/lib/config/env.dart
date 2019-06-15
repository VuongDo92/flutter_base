import 'dart:async';
import 'dart:isolate';

import 'package:bittrex_app/app.dart';
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

    // Init providers and repositories and blocs
    final all = await Future.wait([
//      container.resolve<AccountRepository>().init(),
//      container.resolve<RemoteConfigProvider>().init(),
//      container.resolve<LocalStorageProvider>().getString('locale'),
    ]);

//    container.resolve<PushProvider>().init();

    String localeString = /* all.last as String ??*/ 'en';

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
//    container.registerSingleton<PushProvider, FirebasePushProvider>(
//        (c) => FirebasePushProvider());
//    container.registerSingleton<ApiProvider, DioApiProvider>(
//        (c) => DioApiProvider(apiBaseUrl + '/' + apiVersion));
//    container.registerSingleton<SecretProvider, SecureStorageProvider>(
//        (c) => SecureStorageProvider());
//
//    container.registerSingleton<LocalStorageProvider, MobileStorageProvider>(
//        (c) => MobileStorageProvider());
//    WsProvider swProvider = MobileWsProvider(
//      url: apiBaseUrl,
//      path: '/$apiVersion/socket.io/',
//    );
//    container
//        .registerSingleton<WsProvider, MobileWsProvider>((c) => swProvider);
//
//    final FirebaseRemoteConfigProvider remoteConfigProvider =
//        FirebaseRemoteConfigProvider();
//    container.registerSingleton<RemoteConfigProvider,
//        FirebaseRemoteConfigProvider>((c) => remoteConfigProvider);
  }

  void _registerRepositories() {
//    final apiProvider = container.resolve<ApiProvider>();
//    final secretProvider = container.resolve<SecretProvider>();
//    final localStorageProvider = container.resolve<LocalStorageProvider>();
//    final wsProvider = container.resolve<WsProvider>();
//    final remoteConfigProvider = container.resolve<RemoteConfigProvider>();
//    final pushProvider = container.resolve<PushProvider>();
//    final AccountRepository accountRepository = AccountRepository(
//      apiProvider,
//      secretProvider,
//      localStorageProvider,
//      wsProvider,
//      pushProvider,
//    );
//
//    container.registerSingleton((c) => accountRepository);
//    container.registerSingleton((c) => FeedRepository(apiProvider));
//    container.registerSingleton((c) => InboxRepository(apiProvider));
//    container
//        .registerSingleton((c) => ActivityNotificationRepository(apiProvider));
//    container.registerSingleton((c) => ProfileRepository(apiProvider));
//    container.registerSingleton((c) => GroupRepository(
//          apiProvider,
//          wsProvider,
//          accountRepository,
//        ));
//    container.registerSingleton((c) => GameRepository(
//          apiProvider,
//          wsProvider,
//          accountRepository,
//        ));
//    container.registerSingleton((c) => ScoreRepository(apiProvider));
//    container.registerSingleton((c) => CommentRepository(apiProvider));
//    container.registerSingleton(
//      (c) => PartnerRepository(apiProvider, accountRepository),
//    );
//    container.registerSingleton(
//      (c) => ExploreRepository(
//            apiProvider,
//            localStorageProvider,
//            accountRepository,
//            defaultRadius: remoteConfigProvider.defaultRadius,
//          ),
//    );
//    container.registerSingleton((c) => PulseRepository(apiProvider));
//    container.registerSingleton((c) => SettingRepository(apiProvider));
//    container.registerSingleton(
//        (c) => ExploreSortOptionsRepository(localStorageProvider));
//    container.registerSingleton(
//        (c) => ProfileSportRepository(apiProvider, localStorageProvider));
//    container.registerSingleton((c) => InvitePlayerRepository(
//          apiProvider,
//          localStorageProvider,
//        ));
//    container.registerSingleton((c) => RankingRepository(apiProvider));
//    container.registerSingleton((c) => TooltipRepository(localStorageProvider));
//    container.registerSingleton((c) => AssessmentRepository(apiProvider));
  }
}
