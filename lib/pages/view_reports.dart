import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/global_var.dart';
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
    // local_notifs().show_notifs(title: "DAIRY",body: "There are $a new alerts");
    CoolAlert.show(
        context: context,
        type: CoolAlertType.info,
        width: 20.0,
        text: "There are $a new alerts",
        title: "Update");
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
    String details = a["details"];
    String ph = a["ph"];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      padding: EdgeInsets.symmetric(
          vertical: global_var.height * 0.05,
          horizontal: global_var.width * 0.08),
      height: global_var.height * 0.7,
      decoration: BoxDecoration(
          color: AppStyle.bodyColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          report_lines("Name", name),
          report_lines("Phone no.", ph),
          report_lines("Emai Id", email),
          report_lines("Address", addr),
          report_lines("Latitude", lat),
          report_lines("Longitude", lng),
          report_lines("Type of Incdient", type),
          report_lines("Description", details),
        ],
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
            Flexible(
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
}
