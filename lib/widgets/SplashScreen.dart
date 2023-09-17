import 'package:dairy/format/color_palette.dart';
import 'package:dairy/pages/base_screen.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Appstyle AppStyle=Appstyle();
  futureScreen()async{
    await Future.delayed(Duration(seconds: 3),);
    Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>base_screen(),
        transitionsBuilder:(context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      transitionDuration: Duration(milliseconds: 300)
    )
    );

}
@override
void initState() {
  // TODO: implement initState
  super.initState();
  futureScreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bodyColor,
      body: Center(
        child: Container(
          width: 200,height: 200,
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
