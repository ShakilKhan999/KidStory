import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kids_story/providers/chat_gpt_provider.dart';
import 'package:kids_story/screens/forgot_password_page.dart';
import 'package:kids_story/screens/loading_page.dart';
import 'package:kids_story/screens/login_page.dart';
import 'package:kids_story/screens/read.dart';
import 'package:kids_story/screens/signup.dart';
import 'package:kids_story/screens/splash.dart';
import 'package:kids_story/screens/story_create_and_list.dart';
import 'package:kids_story/screens/subscription_plan.dart';
import 'package:kids_story/screens/verify_email_page.dart';
import 'package:provider/provider.dart';

import 'classess/language_constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_live_51MdNLGJ2SDEUJSiC8SnnPg2r74v7NymIRvfdlB33BeusR08MEUTOADzjVlSt7otdx9Pv5phwLJbEeqqyhlcr2T9k00mrXqMwfE';
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ChaGptProvider()),
          ],
          child: MaterialApp(
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: _locale,
              title: 'KidStories',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: SplashScreen.routeName,
              routes: {
                ReadingPage.routeName: (context) => ReadingPage(),
                SplashScreen.routeName: (context) => const SplashScreen(),
                LoginPage.routeName: (context) => const LoginPage(),
                SignUpPage.routeName: (context) => const SignUpPage(),
                StoryCreateAndList.routeName: (context) =>
                    const StoryCreateAndList(),
                SubscriptionPage.routeName: (context) => SubscriptionPage(),
                ForgotPasswordScreen.routeName: (context) =>
                    const ForgotPasswordScreen(),
                VerifyEmailPage.routeName: (context) => const VerifyEmailPage(),
                LoadingPage.routeName: (context) => LoadingPage()
              }),
        );
      },
    );
  }
}
