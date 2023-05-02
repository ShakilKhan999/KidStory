import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_story/screens/verify_email_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_service.dart';
import '../classess/language.dart';
import '../classess/language_constants.dart';
import '../customs/glass.dart';
import '../main.dart';
import 'login_page.dart';

class LanguageSelector extends StatefulWidget {
  static const String routeName = 'languageselectpage';
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String? currentlanguage;
  @override
  getlanguage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String langcode = _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
    for (int i = 0; i < 9; i++) {
      if (langcode == "fr") {
        setState(() {
          currentlanguage = "Français";
        });
      } else if (langcode == "ar") {
        currentlanguage = "اَلْعَرَبِيَّةُ";
      } else if (langcode == "bn") {
        currentlanguage = "বাংলা";
      } else if (langcode == "de") {
        currentlanguage = "Deutsch";
      } else if (langcode == "es") {
        currentlanguage = "Español";
      } else if (langcode == "hi") {
        currentlanguage = "हिंदी";
      } else if (langcode == "pt") {
        currentlanguage = "Português";
      } else if (langcode == "zh") {
        currentlanguage = "中国人";
      } else
        currentlanguage = "English";
    }
  }

  @override
  Widget build(BuildContext context) {
    getlanguage();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'images/bg-6.jpeg',
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.zero),
            child: GlassBox(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'images/lng.png',
                  height: 200,
                  width: 200,
                ),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(.6),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 4,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chAnge,
                        style: TextStyle(color: Colors.red, fontSize: 25.sp),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!.langUage,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(60)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            child: DropdownButton<Language>(
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.language,
                                color: Colors.black,
                                size: 30.sp,
                              ),
                              hint: Text(
                                AppLocalizations.of(context)!.myLanguage,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              onChanged: (Language? language) async {
                                setState(() {
                                  getlanguage();
                                });
                                if (language != null) {
                                  Locale _locale =
                                      await setLocale(language.languageCode);
                                  MyApp.setLocale(context, _locale);
                                }
                              },
                              items: Language.languageList()
                                  .map<DropdownMenuItem<Language>>(
                                    (e) => DropdownMenuItem<Language>(
                                      value: e,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            e.flag,
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                          Text(
                                            e.name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences _prefs =
                            await SharedPreferences.getInstance();
                        String langcode =
                            _prefs.getString(LAGUAGE_CODE) ?? ENGLISH;
                        if (langcode == 'en') {
                          Locale _locale = await setLocale('en');
                          MyApp.setLocale(context, _locale);
                        }
                        if (AuthService.user == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VerifyEmailPage()));
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent[400]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.neXt,
                              style: TextStyle(fontSize: 20.0.sp),
                            ),
                            Icon(
                              Icons.navigate_next,
                              size: 20.sp,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
