import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kids_story/auth/auth_service.dart';
import 'package:kids_story/screens/language_select.dart';
import 'package:kids_story/screens/login_page.dart';
import 'package:kids_story/screens/story_create_and_list.dart';
import 'package:kids_story/screens/verify_email_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classess/language_constants.dart';
import '../utils/glass_box.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splashscreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    super.initState();
      Timer(
        const Duration(seconds: 2),
            () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              String langcode = _prefs.getString(LAGUAGE_CODE) ?? "null";
          if (AuthService.user != null) {
            if(langcode=="null")
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguageSelector()));
              }
            else{
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VerifyEmailPage()));
            }
          }
          else {
            if(langcode=="null")
            {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageSelector()));
            }
            else{
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          }
        },
      );
    // Timer(
    //     const Duration(seconds: 2),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const LoginPage())));
  }
  @override
  Widget build(BuildContext context) {
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
            ),
            child:  GlassBox(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/splash1.png',
                height: 400,
                width: 400,
              ),
              const Text(
                'KidStories',
                style: TextStyle(
                    fontFamily: 'Dunley',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 45),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 70,
                width: 70,
                child: Lottie.asset(
                  'images/lottie/loading.json',
                  animate: true,
                  repeat: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
