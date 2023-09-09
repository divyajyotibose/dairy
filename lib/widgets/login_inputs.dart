import 'package:flutter/material.dart';
import 'package:dairy/format/color_palette.dart';

class login_inputs extends StatelessWidget {
  TextEditingController controller;
  bool visible;
  String label_text, hint_text;
  Icon? pre_icon;
  login_inputs(
      {super.key,
      required this.controller,
      required this.label_text,
      required this.hint_text,
      required this.pre_icon,
      required this.visible});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      maxLines: 1,
      minLines: 1,
      decoration: InputDecoration(
        labelText: label_text,
        hintText: hint_text,
        prefixIcon: pre_icon,
        enabledBorder: OutlineInputBorder(
          borderSide: Appstyle().borderSide,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: Appstyle().borderSide,
        ),
      ),
    );
  }
}
