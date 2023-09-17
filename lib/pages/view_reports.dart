import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/global_var.dart';
import 'package:dairy/pages/MapLoc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dairy/widgets/auth.dart';
import 'package:dairy/widgets/local_notifs.dart';

class view_reports extends StatefulWidget {
  const view_reports({Key? key}) : super(key: key);

  @override
  State<view_reports> createState() => _view_reportsState();
}

class _view_reportsState extends State<view_reports> {
  Uint8List? data;
  String? imageURL;
  Appstyle AppStyle = Appstyle();
  final User? user = auth().currentUser;
  List? allData;
  int? alertCount;
  late final querySnapshot;
  final List<Widget> _items = [];
  CollectionReference collref = FirebaseFirestore.instance.collection("client");
  CollectionReference backref =
      FirebaseFirestore.instance.collection("backend");

  Future<void> signOut() async {
    await auth().signOut();
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      width: 20.0,
      text: "You have logged out ",
      confirmBtnColor: AppStyle.mainColor,
      confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
      backgroundColor: AppStyle.accentColor,
      titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
      textTextStyle: TextStyle(color: AppStyle.contentColor),
    );
  }

  Widget _userid() {
    return Text(user?.email ?? "User email");
  }

  Widget signOutButton() {
    return Container(
      margin: EdgeInsets.all(10),
      child: RawMaterialButton(
        onPressed: signOut,
        elevation: 2.0,
        fillColor: AppStyle.mainColor,
        child: Icon(
          Icons.logout,
          size: 25.0,
          color: AppStyle.contentColor,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //signOut();
  }

  @override
  Widget build(BuildContext context) {
    global_var.context = context;
    return Scaffold(
      body: Container(
        color: AppStyle.accentColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Center(
            child: FutureBuilder(
                future: get_data(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          itemCount: allData!.length,
                          itemBuilder: (context, i) {
                            return tile(i);
                          });
                    }
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    color: AppStyle.contentColor,
                  ));
                }),
          ),
        ),
      ),
      floatingActionButton: signOutButton(),
    );
  }

  get_data() async {
    querySnapshot = await collref.get();
    allData = querySnapshot!.docs.map((doc) => doc.data()).toList();
    final q = await backref.get();
    List? data = q.docs.map((doc) => doc.data()).toList();
    var b = data[0];
    int a = b["alerts"];
    print(b);
    CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        width: 20.0,
        text: "There are $a new alerts",
        title: "Update",
      confirmBtnColor: AppStyle.mainColor,
      confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
      backgroundColor: AppStyle.accentColor,
      titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
      textTextStyle: TextStyle(color: AppStyle.contentColor),);
    backref.doc("reportCount").update({"alerts": 0});
    return allData;
  }

  Widget tile(i) {
    var a = allData![i];
    String name = a["name"];
    String email = a["email"];
    String addr = a["address"];
    double lat = a["latitude"];
    double lng = a["longitude"];
    String type = a["type"];
    String disaster=a["disaster"];
    String cause = a["cause"];
    String details = a["details"];
    String ph = a["ph"];
    String time=a["Time"];
    String date=a["Date"];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      padding: EdgeInsets.symmetric(
          vertical: global_var.height * 0.05,
          horizontal: global_var.width * 0.08),
      height: global_var.height * 0.75,
      decoration: BoxDecoration(
          color: AppStyle.bodyColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 10,color: AppStyle.contentColor)]),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(date,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
              Text(time,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500)),
            ],),
            FutureBuilder(
              future: get_pic(ph),
                builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.done){
                  if(snapshot.hasData){
                    return CircleAvatar(backgroundImage: NetworkImage(snapshot.data.toString()),radius: global_var.ratio*26,backgroundColor: AppStyle.mainColor,);
                  }

                }
                return CircleAvatar(child: Icon(Icons.person,size:  global_var.ratio*26,color: AppStyle.bodyColor,),radius:  global_var.ratio*26,backgroundColor: AppStyle.mainColor,);

                }),
            SizedBox(height: 10,),
            report_lines("Name", name),
            report_lines("Phone no.", ph),
            report_lines("Emai Id", email),
            report_lines("Address", addr),
            report_lines("Latitude", lat),
            report_lines("Longitude", lng),
            report_lines("Type of Incdient", type),
            report_lines("The Incident", disaster),
            report_lines("Description", details),
            report_lines("Cause", cause),
            user_location(lat,lng),
          ],
        ),
      ),
    );
  }

  report_lines(label, data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label : ",
              style: AppStyle.heavyText,
            ),
            Expanded(
                child: Text(
              "$data",
              style: AppStyle.normalText,
              textAlign: TextAlign.right,
            )),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  get_pic(String mobile) async{
    // CoolAlert.show(context: context, type: CoolAlertType.info,title: "get_pic()");

    try {
      await firebaseImage(mobile);
      return imageURL;
    } on FirebaseException catch (e) {
    }
  }
  Future<void> firebaseImage(String mobile) async {
    print(mobile);
    imageURL = await FirebaseStorage.instance.ref().child("files/$mobile").getDownloadURL();

  }

  user_location(lat,lng) {
    return IconButton(
        onPressed: (){
          Navigator.push(context, PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>MapLoc(lat:lat,lng:lng),
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
    }, icon: Icon(Icons.map_rounded,size: 50,color: AppStyle.contentColor,));
  }
}
