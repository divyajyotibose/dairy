import 'package:dairy/format/color_palette.dart';
import 'package:dairy/global_var.dart';
import 'package:dairy/pages/submit_report_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
class imagePreview extends StatelessWidget {
  final image;
  final String mobile;
  imagePreview({Key? key, this.image, required this.mobile}) : super(key: key);
  Appstyle AppStyle= Appstyle();

  Widget Preview(){
    return Container(
      height: global_var.height*0.6,
      width: global_var.width*0.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(image.path!)),
          fit: BoxFit.fill
        )
      ),
    );
  }
  Widget actions(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          backgroundColor: AppStyle.mainColor,
          onPressed: (){
          Navigator.pop(context);
        },
        heroTag: "fn1",
          child: Icon(Icons.undo,color: AppStyle.accentColor,),
        ),
        FloatingActionButton(
          backgroundColor:AppStyle.mainColor,
          onPressed: (){
              final file=File(image.path!);
              final path="files/$mobile";
              final reference=FirebaseStorage.instance.ref().child(path);
              reference.putFile(file);
          int count = 0;
          Navigator.of(context).popUntil((_) => count++ >= 2);
        },
          heroTag: "fn2",
          child: Icon(Icons.check,color: AppStyle.accentColor,),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    global_var.context=context;
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color:AppStyle.accentColor ,
            image: DecorationImage(
                image: FileImage(File(image.path!)),
                fit: BoxFit.contain
            )),
          child: Stack(
            children: [Positioned(
              bottom: global_var.height*0.055,
              left: global_var.width*0.15,
              right: global_var.width*0.15,
              child:actions(context),
            ),],
          ),
        ));
  }
}
