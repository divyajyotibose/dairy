import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/pages/base_screen.dart';
import 'package:dairy/pages/home_screen.dart';
import 'package:dairy/pages/login_page.dart';
import 'package:dairy/widgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dairy/pages/submit_report_page.dart';
Future<void> main() async{
  Appstyle AppStyle=Appstyle();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
   home: SplashScreen(),
  ));
  }