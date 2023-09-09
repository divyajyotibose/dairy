import 'package:flutter/material.dart';
import 'package:dairy/format/color_palette.dart';

class form_inputs extends StatelessWidget {
  TextEditingController controller;
  String label_text, hint_text;
  Icon? pre_icon;
  form_inputs(
      {Key? key,
      required this.controller,
      required this.hint_text,
      required this.label_text,
      required this.pre_icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(focusColor: Colors.black),
      child: TextField(
        controller: controller,
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
          labelText: label_text,
          hintText: hint_text,
          prefixIcon: pre_icon,
          fillColor: Colors.black,
        ),
      ),
    );
  }
}
