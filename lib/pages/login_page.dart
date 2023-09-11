import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/global_var.dart';
import 'package:dairy/widgets/login_inputs.dart';
import 'package:dairy/widgets/usefulButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dairy/widgets/auth.dart';
import 'package:dairy/global_var.dart';

class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  Appstyle AppStyle = Appstyle();
  TextEditingController id = TextEditingController();
  TextEditingController pwd = TextEditingController();
  String? errorMessage = "";
  bool isLogin = true;
  Future<void> signInWithEmailAndPassword() async {
    try {
      await auth()
          .signInWithEmailAndPassword(email: id.text, password: pwd.text);
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   pwd.text = "";
      //   errorMessage = e.message;
      // });
      CoolAlert.show(context: context,
          type: CoolAlertType.error,
          text:"Invalid username or password" ,
          confirmBtnColor: AppStyle.mainColor,
          confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
          backgroundColor: AppStyle.accentColor,
          titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
          textTextStyle: TextStyle(color: AppStyle.contentColor));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  message() {
    return CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        width: 20.0,
        title: "Restricted Access",
        text: "For authorised personnel only");
  }

  Widget logo() {
    return Container(
      height: global_var.height * 0.15,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/circle_logo.png"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    global_var.context = context;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
        height: global_var.height * 0.65,
        decoration: BoxDecoration(
            // border: Border.all(width: 15, color: color_palette().form_border),
          image: DecorationImage(
            image: AssetImage("assets/images/login.png"),
            fit: BoxFit.fill
          ),
            boxShadow: [
              BoxShadow(
                color:AppStyle.contentColor,
                blurRadius: 10,
              )
            ],
            color: AppStyle.bodyColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.symmetric(
            vertical: global_var.height * 0.06,
            horizontal: global_var.width * 0.11),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              logo(),
              SizedBox(
                height: 20,
              ),
              login_inputs(
                controller: id,
                label_text: "id",
                hint_text: "Enter email id",
                pre_icon: Icon(Icons.mail),
                visible: true,
              ),
              SizedBox(
                height: 20,
              ),
              login_inputs(
                controller: pwd,
                label_text: "password",
                hint_text: "Enter your password",
                pre_icon: Icon(Icons.key),
                visible: false,
              ),
              SizedBox(height: 15),
              // _errorMessage(),
              usefulButton(fn: signInWithEmailAndPassword, label: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}
