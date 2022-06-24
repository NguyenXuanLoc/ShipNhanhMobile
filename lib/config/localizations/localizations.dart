// @dart = 2.9
import 'package:flutter/material.dart';

/// Contains strings for app
/// TODO: implement later
class AppLocalizations {
//  static Future<AppLocalizations> load(Locale locale) {
//    final String name =
//    locale.countryCode == null ? locale.languageCode : locale.toString();
//    final String localeName = Intl.canonicalizedLocale(name);
//
//    return initializeMessages(localeName).then((bool _) {
//      Intl.defaultLocale = localeName;
//      return new AppLocalizations();
//    });
//  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}