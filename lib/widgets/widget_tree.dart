import "auth.dart";
import 'package:dairy/pages/view_reports.dart';
import 'package:dairy/pages/login_page.dart';
import 'package:flutter/material.dart';
class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:auth().AuthStateChanges,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: view_reports(),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);}
          );
        }
        else{
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: login_page(),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);}
          );
        }
      },
    );
  }
}
