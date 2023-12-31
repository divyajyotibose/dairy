import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/global_var.dart';
import 'package:dairy/pages/submit_report_page.dart';
import 'package:dairy/widgets/pageAnimation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'imagePreview.dart';
class selfie_page extends StatefulWidget {
  String mobile;
  final CameraDescription?  camera;


  selfie_page({Key? key,required this.mobile,required this.camera}) : super(key: key);

  @override
  State<selfie_page> createState() => _selfie_pageState();
}

class _selfie_pageState extends State<selfie_page> {
  Appstyle AppStyle = Appstyle();
  List<CameraDescription>?  cameras;
  late CameraController _cam;
  late Future<void> _initializeControllerFuture;
  var image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cam=CameraController(widget.camera!, ResolutionPreset.medium);
    _initializeControllerFuture= _cam.initialize();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _cam.dispose();
    super.dispose();
  }
  photo_button()  {
    return Positioned(
      bottom: global_var.ratio*30,
      left: global_var.width*0.44,
      child: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          await _initializeControllerFuture;

          // Attempt to take a picture and then get the location
          // where the image file is saved.
          image = await _cam.takePicture();
          update();

        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      }, child: Center(child: Icon(Icons.motion_photos_on_rounded,size: global_var.ratio*28,color: AppStyle.accentColor,)),
      backgroundColor: AppStyle.mainColor,
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    global_var.context=context;
    return Scaffold(
      body: FutureBuilder(
          future: _initializeControllerFuture,
          builder:(context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: AppStyle.accentColor,
                      ),
                      child: Center(
                        child: CameraPreview(_cam,),
                      )),
                  photo_button(),

                ],
              );
            }
            else{
              return Container(color:AppStyle.accentColor,child: Center(child: CircularProgressIndicator(color: AppStyle.contentColor,),));
            }
          }
      ),
    );
  }

  update()async{
    // CoolAlert.show(
    //   context: context,
    //   type: CoolAlertType.success,
    //   width:20.0,
    //   text: "Selfie taken successfully",
    //   confirmBtnColor: AppStyle.mainColor,
    //   confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
    //   backgroundColor: AppStyle.accentColor,
    //   titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
    //   textTextStyle: TextStyle(color: AppStyle.contentColor),
    // );

    Navigator.push(context, pageAnimation().getAnimation(imagePreview(image: image,mobile:widget.mobile))
    );

  }


}
