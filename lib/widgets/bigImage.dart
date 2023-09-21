import 'package:dairy/format/color_palette.dart';
import 'package:flutter/material.dart';
class bigImage extends StatelessWidget {
  const bigImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Appstyle AppStyle=Appstyle();
    return Scaffold(
      backgroundColor: AppStyle.accentColor,
      body: Center(
        child: Container(
          child: Image.asset("assets/images/prog.jpg")),
        ),
      );
  }
}
