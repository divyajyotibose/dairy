import 'dart:ui';
import 'dart:io';
import 'package:animated_check/animated_check.dart';
import 'package:camera/camera.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/pages/selfie_page.dart';
import 'package:dairy/widgets/local_notifs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:dairy/global_var.dart';
import 'package:flutter/material.dart';
import 'package:dairy/format/color_palette.dart';
import '../widgets/form_inputs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class submit_report_page extends StatefulWidget {
  const submit_report_page({Key? key}) : super(key: key);

  @override
  State<submit_report_page> createState() => _submit_report_pageState();
}

class _submit_report_pageState extends State<submit_report_page> with SingleTickerProviderStateMixin{
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController details=TextEditingController();
  TextEditingController mobile=TextEditingController();
  CollectionReference collRef=FirebaseFirestore.instance.collection("client");
  CollectionReference backref=FirebaseFirestore.instance.collection("backend");
  late AnimationController _controller;
  late Animation<double> animation;
  List listItem=["Selection a disaster type","Tornado","Flood","Earthquake"];
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  String? fcmToken;
  List<CameraDescription>?  cameras;
  CameraDescription? cam;
  var image;



  String? ip,valueChoose;
  Future<void> send_data() async {
    if(name.text=="" || email.text==""|| details.text==""|| mobile.text=="" || valueChoose==listItem[0]){
      CoolAlert.show(context: context, type: CoolAlertType.warning,width:20.0,text: "Please fill all fields",title:"Warning!!");

    }
    else{
      await collRef.doc(mobile.text).set({
        "name":name.text,
        "email":email.text,
        "details":details.text,
        "type":valueChoose,
        "ip":ip,
        "Time":get_time(),
        "latitude":_currentPosition?.latitude??"",
        "longitude":_currentPosition?.longitude??"",
        "address":_currentAddress??"",
        "ph":mobile.text
      }).whenComplete(() async {
        // showDialog(context: context, builder: (_)=>alert_message(title: AnimatedCheck(progress: animation, size: 200,color: Colors.greenAccent,), content: Text("Report Submitted Successfully")));
        CoolAlert.show(context: context, type: CoolAlertType.success,width:20.0,title: "Report Submitted",text:"");
        setState(() {
          name.text="";
          email.text="";
          details.text="";
          mobile.text="";
        });
        await backref.doc("reportCount").update({
          "alerts":FieldValue.increment(1),
        });
      });

    }

  }
  Widget submit_button(){
    return ElevatedButton(
        onPressed:send_data,
        child:const Text("Submit"),
        style: ElevatedButton.styleFrom(
          backgroundColor: color_palette().submit_button_color,
          shape: StadiumBorder(),
          padding: EdgeInsets.all(15)
        ),

    );
  }
  Widget selection_menu(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: color_palette().form_border,width: color_palette().form_width)
      ),
      child: DropdownButton(
        value: valueChoose,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down),
        onChanged:(newValue){
          setState(() {
            valueChoose=newValue.toString();
          });
        },

        items: listItem.map((valueItem){
          return DropdownMenuItem(
              value: valueItem,
              child:Text(valueItem)
          );
        }).toList(),
        underline: SizedBox(),
        focusColor: Colors.white,
      ),
    );
  }
  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    init();
    get_cam();
    valueChoose=listItem[0];
    local_notifs().initNotifications();
    _controller=AnimationController(vsync: this,duration: Duration(seconds: 2))..forward()..repeat();
    animation =  Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCirc)
    );
    // sender_photo();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  Future init()async{
    // final ipAddress=await ip_api.getIpAddress();
    // setState(() {
    //   ip=ipAddress!;
    // });
  }

  @override
  Widget build(BuildContext context) {
    global_var.context=context;
    return Container(

          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              child: Container(
                height: global_var.height*0.7,
                decoration: BoxDecoration(
                  border: Border.all(width: 15,color: color_palette().form_border),
                  boxShadow:  [
                    BoxShadow(
                      color: color_palette().light,
                      blurRadius: 10,

                    )
                  ],
                  color: color_palette().form_color,
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                padding: EdgeInsets.symmetric(vertical:global_var.height*0.05,horizontal:global_var.width*0.15),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    form_inputs(controller: name, label_text: "Name", hint_text: "Enter your name", pre_icon: const Icon(Icons.person)),
                    const SizedBox(height: 10,),
                    form_inputs(controller: email, label_text: "Email id", hint_text: "Enter your email id", pre_icon: const Icon(Icons.mail)),
                    const SizedBox(height: 10,),
                    PhoneFieldHint(
                      controller: mobile,
                    ),
                    SizedBox(height: 10,),
                    selection_menu(),
                    const SizedBox(height: 10,),
                    description_box(),
                    const SizedBox(height: 10,),
                    take_photo(),
                    SizedBox(height: 10,),
                    submit_button(),

                  ],
                ),
              ),
            ),
          ),
        );

  }

  description_box() {
    return SingleChildScrollView(
      child: SizedBox(
        child: form_inputs(
          controller: details,
          label_text: "Description",
          hint_text: "Please describe the incident",
          pre_icon: const Icon(Icons.description),),
      ),
    );
  }
  get_time(){
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String tdata = DateFormat("HH:mm:ss").format(DateTime.now());
    String datetime="$cdate, $tdata";
    return datetime;
  }


Widget take_photo(){
    return TextButton(
        onPressed:()  async {
          if(mobile.text==""){
            CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                text: "Please enter your phone number",
            );

          }
          else{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => selfie_page(mobile: mobile.text, camera: cam,)),
            );
          }

        },
        child: Icon(Icons.camera_alt_outlined),
      style: TextButton.styleFrom(
        backgroundColor:color_palette().submit_button_color,
        shape: CircleBorder(),
        iconColor: color_palette().form_color
    ),
    );
}

get_cam()async{
cameras=await availableCameras();
cam=cameras![1];
}


}
