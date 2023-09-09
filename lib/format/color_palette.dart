import 'package:flutter/material.dart';
class color_palette{
  Color light=Color(0xff9F91CC);
  Color dark=Color(0xff5C4B99);
Color get border_color => dark;
double border_width=1;

BorderSide get bs => BorderSide(width: border_width,color: border_color);

Color bg_color = Colors.deepPurple;
Color form_color= Color(0xffFFDBC3);
Color get form_border=>dark;
double form_width=1;
BorderSide get fs=> BorderSide(width:form_width,color:form_border );

Color get submit_button_color=> Color(0xff5C4B99);
Color get navbar_color=> Color(0xff0D1282);
TextStyle get report_label_style=>TextStyle(
  fontSize:16,
  fontWeight: FontWeight.bold
);
  TextStyle get report_data_style=>TextStyle(
    fontSize:16,

  );
}