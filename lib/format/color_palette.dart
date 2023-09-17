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

// class color_palette {
//   Color light = Color(0xff9F91CC);
//   Color dark = Color(0xff5C4B99);
//   Color border_color = Color(0xff5C4B99);
//   double border_width = 1;
//
//   BorderSide get bs => BorderSide(width: border_width, color: border_color);
//
//   Color bg_color = Colors.deepPurple;
//   Color form_color = Color(0xffFAF1E4);
//   Color get form_border => dark;
//   double form_width = 1;
//   BorderSide get fs => BorderSide(width: form_width, color: form_border);
//
//   Color get submit_button_color => Color(0xff5C4B99);
//   Color navbar_color = Color(0xff9EB384);
//   TextStyle get report_label_style =>
//       TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
//   TextStyle get report_data_style => TextStyle(
//         fontSize: 16,
//       );
// }
