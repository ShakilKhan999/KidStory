import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
   GlassBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.white, width: 10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(1),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
