import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/pages/submit_report_page.dart';
import 'package:dairy/pages/view_reports.dart';
import 'package:flutter/material.dart';

import '../widgets/widget_tree.dart';
import 'home_screen.dart';
class base_screen extends StatefulWidget {
  const base_screen({Key? key}) : super(key: key);

  @override
  State<base_screen> createState() => _base_screenState();
}

class _base_screenState extends State<base_screen> {
  int _selectedIndex=0;
  var page;
  change_pages(currentIndex) {

    if (currentIndex == 0) {
      page = const home_screen();
      setState(() {
        _selectedIndex = currentIndex;
      });
    }
    if (currentIndex == 1) {
      page = const submit_report_page();
      setState(() {
        _selectedIndex = currentIndex;
      });
    }
    else if (currentIndex == 2) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          width:20.0,
          title: "Restricted Access!",
          text:"For authorised personnel only",
      onConfirmBtnTap: (){
            setState(() {
              page = const WidgetTree();
              _selectedIndex=currentIndex;
            });
      },
          confirmBtnText: "Proceed",
      cancelBtnText: "Go Back",
      showCancelBtn: true,
      );
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page=home_screen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/download.jpeg"))
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: page,
            transitionBuilder: (Widget child, Animation<double> animation) {
    return ScaleTransition(scale: animation, child: child);}
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: color_palette().navbar_color,
        ),
        child: BottomNavigationBar(
          iconSize: 30,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.amber,
          items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.report_gmailerrorred),
              label: "Report"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined),
              label: "View")
        ],
          currentIndex: _selectedIndex,
          onTap: change_pages,

        ),
      ),

    );
  }



}
