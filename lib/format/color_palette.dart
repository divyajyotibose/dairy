import 'package:flutter/material.dart';

class Appstyle {
  Color bodyColor = const Color(0xFFFAF1E4);
  Color contentColor = const Color(0xFF435334);
  Color mainColor = const Color(0xFF9EB384);
  Color accentColor = const Color(0xFFCEDEBD);

  double borderWidth = 1;

  BorderSide get borderSide =>
      BorderSide(width: borderWidth, color: accentColor);

  TextStyle get normalText => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: contentColor
  );
  TextStyle get heavyText => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: contentColor
  );
}

