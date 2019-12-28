import 'dart:io';
import 'dart:ui';
import 'package:kiwi/kiwi.dart' as kiwi;

import 'package:bittrex_app/i18n/application.dart';
import 'package:bittrex_app/i18n/i18n_delegate.dart';
import 'package:bittrex_app/ui/components/buttons/button_size.dart';
import 'package:bittrex_app/ui/theme/theme_state.dart';
import 'package:bittrex_app/ui/utils/exception_utils.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:core/stores/akamai_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import './config/env.dart';
import './routes/routes.dart';
import 'i18n/i18n.dart';
import 'platform_channel.dart';
import 'ui/components/buttons/buttons.dart';
import 'ui/theme/theme.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print(":::TAG::: myBackgroundMessageHandler: $message");

//  await _showBackgroundNotification(message);
}
BuildContext _appContext; // Safe context to get navigator and I18n from

typedef OnError = void Function(dynamic error, {dynamic stack});

// This widget is the root of your application.
class App extends StatefulWidget {
  final AkamaiStore akamaiStore;
  final Env env;
  final Locale locale;

  final GlobalKey<_AppRootState> _rootKey = new GlobalKey<_AppRootState>();

  void onError(dynamic error, {dynamic stack}) {
    if (error is UnauthorizedException) {
      _rootKey.currentState._handleUnauthenticatedError(error);
      return;
    }

    if (error is DeprecationException) {
      _rootKey.currentState._handleApiDeprecationError(error);
      return;
    }

    bool isInDebugMode = false;
    assert(() {
      isInDebugMode = true;
      return true;
    }());

    if (isInDebugMode == false) {
      if (error is MobXException ||
          error is FlutterError ||
          (error is DataProviderException && error.isSilent == true)) {
        debugPrint(error.message);
        // We won't display those error messages in release mode
        ExceptionUtils.show(
          I18n.of(_appContext).text('message_default_error_title'),
        );
        return;
      }
    }

    ExceptionUtils.show(error);

    if (stack != null) {
      debugPrint(stack.toString());
      try {
//        Crashlytics.instance.onError(stack);
      } catch (e) {
        // ignore
      }
    }
  }

  App({
    Key key,
    @required this.env,
    @required this.akamaiStore,
    @required this.locale,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
//  WsProvider _ws = kiwi.Container().resolve<WsProvider>();

  Locale locale;

  @override
  void initState() {
    locale = widget.locale ?? const Locale('en');
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void initRoutes() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('new application state ${state.toString()}');
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Env>.value(value: widget.env),
        Provider<AkamaiStore>.value(value: widget.akamaiStore),
        Provider<ThemeState>.value(value: theme),
      ],
      child: OKToast(
        child: AppRoot(
          key: widget._rootKey,
          akamaiStore: widget.akamaiStore,
          locale: locale,
          env: widget.env,
        ),
        radius: 16.0,
        position: ToastPosition.bottom,
        backgroundColor: AppColors.grayThree,
        textStyle: TextStyleOption.textWhiteBody1().copyWith(
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
        textPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
    );
  }
}

class AppRoot extends StatefulWidget {
  final Locale locale;
  final AkamaiStore akamaiStore;
  final Env env;

  AppRoot({Key key, this.locale, this.env, this.akamaiStore}) : super(key: key);

  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot>
    with TickerProviderStateMixin<AppRoot>, WidgetsBindingObserver {
  AkamaiStore get akamaiStore => widget.akamaiStore;

  PlatformChannel channel;
  I18nDelegate _i18nDelegate;

  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  Locale _deviceLocale;

  void initRoutes() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);

    return MultiProvider(
      providers: [Provider<PlatformChannel>.value(value: channel)],
      child: MaterialApp(
        theme: themeState.theme,
        navigatorKey: _rootNavigatorKey,
        home: Builder(builder: (ctx) {
          _appContext = ctx;
          return Observer(builder: (_) {
            return Container(
              color:
                  akamaiStore.isBusyWithAkamai ? Colors.white : Colors.blueGrey,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: theme.spacingDefault),
                  child: PrimaryButton(
                    size: ButtonSize.normal,
                    onPressed:
                        akamaiStore.isBusyWithAkamai ? null : _loginHandler,
                    child: Text("Login"),
                  ),
                ),
              ),
            );
          });
        }),
        localizationsDelegates: [
          _i18nDelegate,
          //provides localised strings
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: application.supportedLocales(),
        onGenerateRoute: Routes.router.generator,
      ),
    );
  }

  bool _handleNotificationAction(Map<String, dynamic> message) {
    print("_handleNotificationAction");
    if (message == null) {
      print("_handleNotificationAction with message is null");
      return false;
    }
    print("_handleNotificationAction with message is non-null");

    // TODO: handle redirect screen
    return true;
  }

  _loginHandler() {
    akamaiStore.akamaiAuthorize();
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _i18nDelegate = I18nDelegate(newLocale: locale);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    channel = PlatformChannel(onMethodCall);
    initRoutes();

    kiwi.Container().resolve<PushProvider>().init();

    _i18nDelegate = I18nDelegate(newLocale: widget.locale);
    application.onLocaleChanged = onLocaleChange;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      registerDeviceWithDeviceId();
    });
  }

  void registerDeviceWithDeviceId() async {
    var deviceId;

    /// For iOS we store in secrect store to persist between installs
    const storeKeyForIos = 'identifierForVendor';
    if (Platform.isIOS) {
      final secretProvider = container.resolve<SecretProvider>();
      deviceId = await secretProvider.getString(storeKeyForIos);
      if (deviceId == null) {
        try {
          deviceId = await channel.getDeviceUUID();
          await secretProvider.setString(storeKeyForIos, deviceId);
        } catch (e) {
          // ignore
          deviceId = null;
        }
      }
    } else {
      deviceId = await channel.getDeviceUUID();
    }
    if (deviceId != null) {
      akamaiStore.registerDevice(deviceId: deviceId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    debugPrint(
        'Handling platform method call ${call.method}, arguments ${call.arguments}');

    try {
      switch (call.method) {
        default:
          return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handleUnauthenticatedError(UnauthorizedException error) {}

  void _handleApiDeprecationError(DeprecationException error) {}
}

ThemeState get theme => ThemeState(
      theme: new ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          elevation: 0.5,
          color: Colors.white,
          textTheme: TextTheme(
            title: TextStyle(
                color: AppColors.greyBlue,
                fontFamily: 'Lato',
                fontWeight: FontWeight.normal,
                fontSize: 18),
          ),
        ),
        dividerColor: AppColors.silver,
        fontFamily: 'Lato',
        primaryColor: AppColors.turquoise,
        accentColor: AppColors.greyBlue,
        cardTheme: CardTheme(
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.silver, width: 0.5),
            borderRadius: new BorderRadius.circular(6.0),
          ),
        ),
        primaryTextTheme: const TextTheme(
          caption: TextStyle(color: AppColors.greyBlue, fontSize: 15),
          title: TextStyle(
            color: AppColors.greyBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          body1: TextStyle(color: AppColors.greyBlue, fontSize: 15),
          body2: TextStyle(
            color: AppColors.greyBlue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        primaryIconTheme: const IconThemeData(
          color: AppColors.greyBlue,
        ),
        buttonTheme: ButtonThemeData(
          height: 50,
          textTheme: ButtonTextTheme.primary,
          highlightColor: AppColors.turquoise,
          buttonColor: AppColors.turquoise,
          disabledColor: AppColors.turquoise.withOpacity(0.5),
        ),
        textTheme: const TextTheme(
          caption: TextStyle(color: AppColors.greyBlue),
          body1: TextStyle(color: AppColors.greyBlue),
          button: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      devicePixelRatio: window.devicePixelRatio,
    );
