import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_story/screens/signup.dart';

import '../customs/custom_text_field.dart';

class Login extends StatefulWidget {
  static const String routeName = 'loginpage';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double scw = MediaQuery.of(context).size.width;
    double sch = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          child: Center(
            child: Stack(
              children: [
                SizedBox(
                  height: sch,
                  width: scw,
                  child: ClipRRect(
                    child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          "images/logfullbg.jpg",
                          height: sch,
                          width: scw,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: scw,
                      width: scw,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(90)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(90)),
                        child: Image.asset(
                          "images/logbg.jpg",
                          height: scw,
                          width: scw,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'Connexion',
                      style: TextStyle(
                          fontFamily: 'ralsteda',
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF350008)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        height: 260.h,
                        width: 400.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF350008).withOpacity(0.5)),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 35.h,
                              ),
                              CustomFormField(
                                labelText: 'Enter Email',
                                textEditingController: emailcontroller,
                                inputType: TextInputType.text,
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                height: 35.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFF5F5F5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF350008)
                                          .withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    controller: emailcontroller,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: false,
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp),
                                        suffixIcon: const Icon(
                                          Icons.visibility_off,
                                          color: Color(0xFF350008),
                                        ),
                                        hintText: "Mot de passe"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                height: 35.h,
                                width: 300.w,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF350008),
                                      blurRadius: 2,
                                      offset: Offset(0, 1), // Shadow position
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0.5,
                                      backgroundColor: const Color(0xFF775DDD),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  },
                                  child: Text(
                                    "S'identifier",
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Vous avez déjà un compte?",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SignUpPage.routeName);
                                      },
                                      child: Text(
                                        "Connexion",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
