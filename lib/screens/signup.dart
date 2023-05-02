import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kids_story/screens/login_page.dart';
import 'package:kids_story/screens/verify_email_page.dart';
import 'package:kids_story/utils/snackbar.dart';

import '../auth/auth_service.dart';
import '../customs/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = 'signupPage';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  _onPressSignUp() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String createdAt = formatter.format(now);
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
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
    if (confirmPassword.isEmpty) {
      CustomSnackbar(
              context: context,
              title: 'Error',
              message: 'Confirm Password Required')
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
    }
    if (confirmPassword != password) {
      CustomSnackbar(
              context: context,
              title: 'Error',
              message: 'Password does not match')
          .showSnackbar();
      return;
    } else {
      userSignUp(email, password, createdAt);
    }
  }

  userSignUp(String email, String password, String createdAt) async {
    EasyLoading.show();
    await AuthService.signUp(email, password, createdAt, 'free', 'null').then(
      (value) {
        EasyLoading.dismiss();
        Navigator.pushNamed(context, VerifyEmailPage.routeName);
      },
    );
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
          backgroundColor: Colors.black,
          body: Platform.isAndroid
              ? SafeArea(
                  child: SizedBox(
                    height: sch,
                    width: scw,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: sch,
                            width: scw,
                            child: ClipRRect(
                              child: Image.asset(
                                "images/img.jpg",
                                height: sch,
                                width: scw,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Stack(
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
                                          decoration: BoxDecoration(),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.asset(
                                              "images/signcvr.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        CustomFormField(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .enterMail,
                                          textEditingController:
                                              emailController,
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
                                              AppLocalizations.of(context)!
                                                  .enterPass,
                                          textEditingController:
                                              passwordController,
                                          inputType: TextInputType.text,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                          ),
                                          isObscure: true,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        CustomFormField(
                                          labelText:
                                              AppLocalizations.of(context)!
                                                  .confirmPass,
                                          textEditingController:
                                              confirmPasswordController,
                                          inputType: TextInputType.text,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color: Colors.black,
                                          ),
                                          isObscure: true,
                                        ),
                                        SizedBox(
                                          height: 35.h,
                                        ),
                                        Container(
                                          height: 35.h,
                                          width: 220.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0xFF322F2F),
                                                blurRadius: 2,
                                                offset: Offset(
                                                    0, 1), // Shadow position
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
                                                        BorderRadius.circular(
                                                            15))),
                                            onPressed: () {
                                              _onPressSignUp();
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .signUp,
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
                                                  .alreadyhaveAccount,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white54),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacementNamed(
                                                    context,
                                                    LoginPage.routeName);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .logIn,
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
                        ],
                      ),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    SizedBox(
                      height: sch,
                      width: scw,
                      child: ClipRRect(
                        child: Image.asset(
                          "images/img.jpg",
                          height: sch,
                          width: scw,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Stack(
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
                                        "images/signcvr.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  CustomFormField(
                                    labelText:
                                        AppLocalizations.of(context)!.enterMail,
                                    textEditingController: emailController,
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
                                    textEditingController: passwordController,
                                    inputType: TextInputType.text,
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                    isObscure: false,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  CustomFormField(
                                    labelText: AppLocalizations.of(context)!
                                        .confirmPass,
                                    textEditingController:
                                        confirmPasswordController,
                                    inputType: TextInputType.text,
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                    isObscure: false,
                                  ),
                                  SizedBox(
                                    height: 35.h,
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
                                        _onPressSignUp();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.signUp,
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
                                            .alreadyhaveAccount,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white54),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, LoginPage.routeName);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.logIn,
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
                  ],
                )),
    );
  }
}
