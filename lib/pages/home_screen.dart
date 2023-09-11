import 'package:dairy/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dairy/pages/submit_report_page.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:path/path.dart';
import 'package:dairy/widgets/widget_tree.dart';
class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {


  @override
  Widget build(BuildContext context) {
    return   Container(
      child: Column(
        children: [
          Icon(Icons.history),

        ],
      ),
      
          );
  }
}
