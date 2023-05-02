import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatefulWidget {
  static const String routeName ='glass';
  double rad;
   GlassBox({Key? key,this.rad=0}) : super(key: key);

  @override
  State<GlassBox> createState() => _GlassBoxState();
}

class _GlassBoxState extends State<GlassBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.rad),
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
