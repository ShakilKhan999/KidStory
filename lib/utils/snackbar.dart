import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  BuildContext context;
  String title;
  String message;
  CustomSnackbar(
      {required this.context, required this.title, required this.message});
  showSnackbar() {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(
          // bottom: MediaQuery.of(context).size.height -130 ,
          right: 20,
          left: 20),
      duration: const Duration(seconds: 2),
      content: SizedBox(
        height: 80,
        child: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.failure,
        ),
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
