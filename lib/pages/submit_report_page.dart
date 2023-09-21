import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/pages/selfie_page.dart';
import 'package:dairy/widgets/geoLoc.dart';
import 'package:dairy/widgets/local_notifs.dart';
import 'package:dairy/widgets/pageAnimation.dart';
import 'package:dairy/widgets/usefulButton.dart';
import 'package:intl/intl.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:dairy/global_var.dart';
import 'package:flutter/material.dart';
import 'package:dairy/format/color_palette.dart';
import '../widgets/form_inputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class submit_report_page extends StatefulWidget {
  const submit_report_page({Key? key}) : super(key: key);

  @override
  State<submit_report_page> createState() => _submit_report_pageState();
}

class _submit_report_pageState extends State<submit_report_page>
    with SingleTickerProviderStateMixin {
  Appstyle AppStyle = Appstyle();
  geoLoc gl=geoLoc();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController cause = TextEditingController();

  bool isDisabled=true;
  CollectionReference collRef = FirebaseFirestore.instance.collection("client");
  CollectionReference backref =
      FirebaseFirestore.instance.collection("backend");
  late AnimationController _controller;
  late Animation<double> animation;
  List listItem2 = [
    "Tornado",
    "Flood",
    "Earthquake",
    "Landslide",
    "Hurricane",
    "Tsunami",
    "Volcanic eruption"
  ];
  List listItem1 = [
    "Bioterrorism",
    "Civil unrest",
    "Hazardous material spills",
    "Nuclear and radiation accidents",

  ];
  List category=[
    "Natural",
    "Manmade"
  ];

  String messageTitle = "Empty";
  String notificationAlert = "alert";
  String? fcmToken;
  List<CameraDescription>? cameras;
  CameraDescription? cam;
  var image;

  String? ip,date,time;
  String? valueChoose,dtype;
  List listItem=[];
  Future<void> send_data() async {
    if (name.text == "" ||
        email.text == "" ||
        details.text == "" ||
        mobile.text == "" ||
        valueChoose == ""||
    dtype=="") {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          width: 20.0,
          text: "Please fill all fields",
          title: "Warning!!",
        confirmBtnColor: AppStyle.mainColor,
        confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
      backgroundColor: AppStyle.accentColor,
          titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
          textTextStyle: TextStyle(color: AppStyle.contentColor));
    } else {
      get_time();
      await collRef.doc(mobile.text).set({
        "name": name.text,
        "email": email.text,
        "cause":cause.text,
        "details": details.text,
        "type": dtype,
        "disaster":valueChoose,
        "ip": ip,
        "Time": time,
        "Date":date,
        "latitude": gl.currentPosition?.latitude ?? "",
        "longitude": gl.currentPosition?.longitude ?? "",
        "address": gl.currentAddress ?? "",
        "ph": mobile.text
      }).whenComplete(() async {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            width: 20.0,
            text: "Report submitted successfully",
            confirmBtnColor: AppStyle.mainColor,
            confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
            backgroundColor: AppStyle.accentColor,
            titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
            textTextStyle: TextStyle(color: AppStyle.contentColor));
        setState(() {
          name.text = "";
          email.text = "";
          details.text = "";
          mobile.text = "";
          dtype=null;
          valueChoose=null;
          isDisabled=true;
        });
        await backref.doc("reportCount").update({
          "alerts": FieldValue.increment(1),
        });
      });
    }
  }

  Widget selection_menu() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppStyle.mainColor, width: AppStyle.borderWidth)),
      child: DropdownButton(
        value: valueChoose,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down,color: AppStyle.mainColor,),
        dropdownColor: AppStyle.bodyColor,
        onChanged: isDisabled?null:(newValue)=>selectValue(newValue),
        items: listItem.isNotEmpty?listItem.map<DropdownMenuItem<Object>>((valueItem) {
          return DropdownMenuItem(value: valueItem, child: Text(valueItem,style: TextStyle(color: AppStyle.contentColor),));
        }).toList():null,
        underline: SizedBox(),
        hint: Text("Select a disaster"),
        disabledHint: Text("Please select a category first"),

      ),
    );
  }
  Widget disaster_select() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppStyle.mainColor, width: AppStyle.borderWidth)),
      child: DropdownButton(
        value: dtype,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down,color: AppStyle.mainColor,),
        dropdownColor: AppStyle.bodyColor,
        onChanged: (newValue) =>valueChange(newValue),
        items: category.map<DropdownMenuItem<Object>>((valueItem) {
          return DropdownMenuItem(value: valueItem, child: Text(valueItem,style: TextStyle(color: AppStyle.contentColor),));
        }).toList(),
        underline: SizedBox(),
        hint: Text("Select a category"),
      ),
    );
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    init();
    get_cam();
    loc();
    local_notifs().initNotifications();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..repeat();
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
    // sender_photo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future init() async {
    // final ipAddress=await ip_api.getIpAddress();
    // setState(() {
    //   ip=ipAddress!;
    // });
  }

  @override
  Widget build(BuildContext context) {
    global_var.context = context;
    return Scaffold(
      backgroundColor: AppStyle.accentColor,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: global_var.height*0.047),
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/images/submit1.jpeg"),
            //   fit: BoxFit.fill,
            //   opacity: 0.3
            //
            // ),

              boxShadow: [
                BoxShadow(
                  color: AppStyle.contentColor,
                  blurRadius: 10,
                )
              ],
              
              color: AppStyle.bodyColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: global_var.width * 0.15),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                form_inputs(
                    controller: name,
                    label_text: "Name",
                    hint_text: "Enter your name",
                    pre_icon: const Icon(Icons.person)),
                const SizedBox(
                  height: 10,
                ),
                form_inputs(
                    controller: email,
                    label_text: "Email id",
                    hint_text: "Enter your email id",
                    pre_icon: const Icon(Icons.mail)),
                const SizedBox(
                  height: 10,
                ),
                Theme(
                  data: ThemeData(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: AppStyle.contentColor
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      suffixIconColor: AppStyle.contentColor,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppStyle.mainColor),
                      ),
                    )
                  ),
                  child: PhoneFieldHint(
                    controller: mobile,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                disaster_select(),
                SizedBox(height: 10,),
                selection_menu(),

                description_box("Cause","Cause of incident",cause),
                const SizedBox(
                  height: 10,
                ),
                description_box("Description","Please describe the incident",details),
                const SizedBox(
                  height: 10,
                ),
                take_photo(),
                SizedBox(
                  height: 10,
                ),
                usefulButton(fn: send_data, label: "Submit"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  description_box(label,hint,ctr) {
    return SingleChildScrollView(
      child: SizedBox(
        child: form_inputs(
          controller: ctr,
          label_text: label,
          hint_text: hint,
          pre_icon: const Icon(Icons.description),
        ),
      ),
    );
  }

  get_time() {
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
    date = cdate;
    time=tdata;
  }

  Widget take_photo() {
    return TextButton(
      onPressed: () async {
        if (mobile.text == "") {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: "Please enter your phone number",
            confirmBtnColor: AppStyle.mainColor,
            confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
            backgroundColor: AppStyle.accentColor,
              titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
              textTextStyle: TextStyle(color: AppStyle.contentColor),
          );
        } else {
          Navigator.push(
            context,
          pageAnimation().getAnimation(selfie_page(mobile: mobile.text, camera: cam))
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Take a selfie ",style: TextStyle(color: AppStyle.contentColor,fontSize: 16),),
          Icon(Icons.camera_alt_outlined,size: 30,),
        ],
      ),
      style: TextButton.styleFrom(
          backgroundColor: AppStyle.mainColor,
          shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          iconColor: AppStyle.contentColor),
    );
  }

  get_cam() async {
    cameras = await availableCameras();
    cam = cameras![1];
  }

  valueChange(Object? newValue) {

      setState(() {
        isDisabled=false;
        dtype=newValue.toString();
        if(dtype==category[0]) {
          listItem = listItem2;
        }
        else{
          listItem=listItem1;
        }
      });

  }

  selectValue(Object? newValue) {
    setState(() {
      valueChoose=newValue.toString();
    });
  }
  loc(){
    gl.getCurrentPosition1();
  }
}
