import 'dart:ui';

import 'package:bittrex_app/i18n/application.dart';
import 'package:bittrex_app/i18n/i18n_delegate.dart';
import 'package:bittrex_app/ui/screens/home_screen.dart';
import 'package:bittrex_app/ui/theme/theme_state.dart';
import 'package:bittrex_app/ui/utils/exception_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import './config/env.dart';
import './routes/routes.dart';
import 'ui/theme/theme.dart';

typedef OnError = void Function(dynamic error, {dynamic stack});

// This widget is the root of your application.
class App extends StatefulWidget {
//  final AccountStore accountStore;
  final Env env;
  final Locale locale;

  void onError(dynamic error, {dynamic stack}) {
    if (error is MobXException) {
      // We won't display or log Mobx error
      return;
    }
    ExceptionUtils.show(error);
    if (stack != null) {
      debugPrint(stack.toString());
    }
  }

  App({
    Key key,
    @required this.env,
//    @required this.accountStore,
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('new application state ${state.toString()}');
    switch (state) {
      case AppLifecycleState.resumed:
//        _ws.connect();
        break;
      default:
//        _ws.disconnect();
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
        Provider<ThemeState>.value(value: theme),
      ],
      child: OKToast(
        child: AppRoot(
          locale: locale,
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

  AppRoot({Key key, this.locale}) : super(key: key);

  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  I18nDelegate _i18nDelegate;
  void initRoutes() {
    Routes.configureRoutes(Routes.router);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    return MaterialApp(
      theme: themeState.theme,
      home: HomeScreen(),
      localizationsDelegates: [
        _i18nDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: application.supportedLocales(),
      onGenerateRoute: Routes.router.generator,
    );
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
    initRoutes();
    _i18nDelegate = I18nDelegate(newLocale: widget.locale);
    application.onLocaleChanged = onLocaleChange;
  }
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
