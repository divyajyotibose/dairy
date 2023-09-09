import 'package:flutter/material.dart';
class global_var{
  static BuildContext? context;
  static get size=>MediaQuery.of(context!).size;
  static double get height=>MediaQuery.of(context!).size.height;
  static double get width=>MediaQuery.of(context!).size.width;
  static double get ratio=>height/width;




}