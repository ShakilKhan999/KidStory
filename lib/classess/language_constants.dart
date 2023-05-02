import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String ARABIC = 'ar';
const String HINDI = 'hi';
const String SPANISH = 'es';
const String GERMAN = 'de';
const String PORTUGUESE = 'pt';
const String CHINESE = 'zh';
const String BANGLA = 'bn';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return const Locale(ENGLISH, '');
    case FRENCH:
      return const Locale(FRENCH, "");
    case ARABIC:
      return const Locale(ARABIC, "");
    case HINDI:
      return const Locale(HINDI, "");
    case SPANISH:
      return const Locale(SPANISH, "");
    case GERMAN:
      return const Locale(GERMAN, "");
    case PORTUGUESE:
      return const Locale(PORTUGUESE, "");
    case CHINESE:
      return const Locale(CHINESE, "");
    case BANGLA:
      return const Locale(BANGLA, "");
    default:
      return const Locale(ENGLISH, '');
  }
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}
