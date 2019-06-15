import 'package:bittrex_app/ui/screens/home_screen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static final router = Router();

  static const String root = "/";

  static void configureRoutes(Router router) {
    GlobalKey<HomeScreenState> homeScreenKey = GlobalKey();

    router.notFoundHandler = new Handler(handlerFunc: (
      BuildContext context,
      Map<String, List<String>> params,
    ) {
      print(params);
    });

    router.define(
      root,
      handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return HomeScreen(/*key: homeScreenKey*/);
        },
      ),
    );
  }
}
