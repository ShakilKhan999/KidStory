import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../customs/glass.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/reset_password';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

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
            child: GlassBox(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/lock.png',
                height: 300,
                width: 400,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "${AppLocalizations.of(context)!.forGot}\n${AppLocalizations.of(context)!.passWord} ",
                      style: TextStyle(
                        fontSize: 25.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: '@Email ID',
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 35,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF322F2F),
                      blurRadius: 2,
                      offset: Offset(0, 1), // Shadow position
                    ),
                  ],
                ),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.5,
                        backgroundColor: const Color(0xFFF44236),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      resetPassword();
                    },
                    child: Text("${AppLocalizations.of(context)!.sentEmail}")),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Navigator.of(context).pop();
      const snackBar = SnackBar(
        content: Text(
          'Reset mail sent',
          style: TextStyle(color: Color(0xFFF44236)),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
    }
  }
}
