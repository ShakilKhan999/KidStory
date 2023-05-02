import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_story/screens/signup.dart';
import 'package:kids_story/screens/verify_email_page.dart';

import '../auth/auth_service.dart';
import '../customs/custom_text_field.dart';
import '../utils/snackbar.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'loginpage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailControllr = TextEditingController();
  TextEditingController passwordControllr = TextEditingController();
  String errmsg = '';

  _onPressSignIn() {
    String email = emailControllr.text;
    String password = passwordControllr.text;

    if (email.isEmpty) {
      CustomSnackbar(
              context: context, title: 'Error', message: 'Email Required')
          .showSnackbar();
      return;
    }
    if (password.isEmpty) {
      CustomSnackbar(
              context: context, title: 'Error', message: 'Password Required')
          .showSnackbar();
      return;
    }
    if (password.length < 6) {
      CustomSnackbar(
              context: context,
              title: 'Error',
              message: 'Password Must Be 6 character')
          .showSnackbar();
      return;
    } else {
      userSignIn(email, password);
    }
  }

  userSignIn(String email, String password) async {
    EasyLoading.show(status: 'loading...');
    try {
      final status = await AuthService.signIn(email, password);
      EasyLoading.dismiss();
      if (status) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, VerifyEmailPage.routeName);
        }
      } else {
        await AuthService.logout();
        setState(() {
          errmsg;
        });
      }
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss();
      setState(() {
        errmsg = error.message!;
        CustomSnackbar(context: context, title: 'Error', message: errmsg)
            .showSnackbar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double scw = MediaQuery.of(context).size.width;
    double sch = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Platform.isAndroid
            ? SafeArea(
                child: Stack(
                  children: [
                    SizedBox(
                      height: sch,
                      width: scw,
                      child: ClipRRect(
                        child: Image.asset(
                          "images/bg-6.jpeg",
                          height: sch,
                          width: scw,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Stack(
                        children: [
                          ClipRRect(
                            child: SizedBox(
                              width: scw,
                              height: sch,
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2),
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0.1)
                                    ])),
                          ),
                          Positioned(
                            top: 5,
                            left: 5,
                            right: 5,
                            child: Container(
                              width: 400.w,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60),
                                    topRight: Radius.circular(60)),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      height: 300.h,
                                      width: scw,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          "images/img3.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70.h,
                                    ),
                                    CustomFormField(
                                      labelText: AppLocalizations.of(context)!
                                          .enterMail,
                                      textEditingController: emailControllr,
                                      inputType: TextInputType.text,
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    CustomFormField(
                                      labelText: AppLocalizations.of(context)!
                                          .enterPass,
                                      textEditingController: passwordControllr,
                                      inputType: TextInputType.text,
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                      isObscure: true,
                                    ),
                                    // SizedBox(
                                    //   height: 20.h,
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .forgetPass,
                                          style: const TextStyle(
                                              color: Colors.white54),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ForgotPasswordScreen.routeName);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .clickHere,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      height: 35.h,
                                      width: 220.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xFF322F2F),
                                            blurRadius: 2,
                                            offset:
                                                Offset(0, 1), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0.5,
                                            backgroundColor:
                                                const Color(0xFFF44236),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15))),
                                        onPressed: () {
                                          _onPressSignIn();
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.logIn,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .donthaveAccount,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white54),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacementNamed(
                                                context, SignUpPage.routeName);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .signUp,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: sch,
                    width: scw,
                    child: ClipRRect(
                      child: Image.asset(
                        "images/bg-6.jpeg",
                        height: sch,
                        width: scw,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Stack(
                      children: [
                        ClipRRect(
                          child: SizedBox(
                            width: scw,
                            height: sch,
                            child: Stack(
                              children: [
                                BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2),
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.white.withOpacity(0.5),
                                    Colors.white.withOpacity(0.1)
                                  ])),
                        ),
                        Positioned(
                          child: Container(
                            width: 400.w,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60),
                                  topRight: Radius.circular(60)),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 300.h,
                                    width: scw,
                                    decoration: BoxDecoration(),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        "images/img3.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 70.h,
                                  ),
                                  CustomFormField(
                                    labelText:
                                        AppLocalizations.of(context)!.enterMail,
                                    textEditingController: emailControllr,
                                    inputType: TextInputType.text,
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomFormField(
                                    labelText:
                                        AppLocalizations.of(context)!.enterPass,
                                    textEditingController: passwordControllr,
                                    inputType: TextInputType.text,
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    isObscure: true,
                                  ),
                                  // SizedBox(
                                  //   height: 20.h,
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .forgetPass,
                                        style: const TextStyle(
                                            color: Colors.white54),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              ForgotPasswordScreen.routeName);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .clickHere,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    height: 35.h,
                                    width: 220.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFF322F2F),
                                          blurRadius: 2,
                                          offset:
                                              Offset(0, 1), // Shadow position
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.5,
                                          backgroundColor:
                                              const Color(0xFFF44236),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onPressed: () {
                                        _onPressSignIn();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.logIn,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .donthaveAccount,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white54),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, SignUpPage.routeName);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.signUp,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
