import 'package:dairy/pages/base_screen.dart';
import 'package:dairy/pages/home_screen.dart';
import 'package:dairy/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'widgets/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dairy/pages/submit_report_page.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
   home: base_screen(),
  ));
  }