import 'dart:async';

import 'package:bittrex_app/i18n/application.dart';
import 'package:flutter/material.dart';
import 'i18n.dart';

class I18nDelegate extends LocalizationsDelegate<I18n> {
  final Locale newLocale;

  const I18nDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return application.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<I18n> load(Locale locale) {
    return I18n.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) {
    if (old is I18nDelegate) {
      return newLocale != old.newLocale;
    }
    return true;
  }
}
