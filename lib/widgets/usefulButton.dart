import 'package:dairy/format/color_palette.dart';
import 'package:flutter/material.dart';
class usefulButton extends StatelessWidget {
  void Function()? fn;
  String label;
  usefulButton({Key? key,required this.fn,required this.label}) : super(key: key);
  Appstyle AppStyle=Appstyle();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: fn,
      child: Text(
        label,
        style: TextStyle(color: AppStyle.contentColor, fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.mainColor,
          shape: StadiumBorder(),
          padding: EdgeInsets.all(15)),
    );

  }
}
