import 'package:cool_alert/cool_alert.dart';
import 'package:dairy/format/color_palette.dart';
import 'package:dairy/pages/submit_report_page.dart';
import 'package:dairy/pages/view_reports.dart';
import 'package:flutter/material.dart';

import '../widgets/widget_tree.dart';

class base_screen extends StatefulWidget {
  const base_screen({Key? key}) : super(key: key);

  @override
  State<base_screen> createState() => _base_screenState();
}

class _base_screenState extends State<base_screen> {
  Appstyle AppStyle = Appstyle();
  int _selectedIndex = 0;
  var page;
  change_pages(currentIndex) {

    if (currentIndex == 0) {
      page = const submit_report_page();
      setState(() {
        _selectedIndex = currentIndex;
      });
    } else if (currentIndex == 1 && _selectedIndex!=1) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        width: 20.0,
        title: "Restricted Access !",
        text: "For authorised personnel only",
        onConfirmBtnTap: () {
          setState(() {
            page = const WidgetTree();
            _selectedIndex = currentIndex;
          });
        },
        confirmBtnText: "Proceed",
        cancelBtnText: "Go Back",
        showCancelBtn: true,
        confirmBtnColor: AppStyle.mainColor,
        confirmBtnTextStyle: TextStyle(color: AppStyle.contentColor),
        backgroundColor: AppStyle.accentColor,
        cancelBtnTextStyle: TextStyle(color: AppStyle.contentColor),
        titleTextStyle: TextStyle(color: AppStyle.contentColor,fontWeight: FontWeight.bold,fontSize: 20),
          textTextStyle: TextStyle(color: AppStyle.contentColor)
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = submit_report_page();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppStyle.accentColor,
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: page,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              }),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(canvasColor: AppStyle.mainColor),
        child: BottomNavigationBar(
          iconSize: 30,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: AppStyle.contentColor,
          unselectedItemColor: AppStyle.bodyColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.report_gmailerrorred), label: "Report"),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_outlined), label: "View")
          ],
          currentIndex: _selectedIndex,
          onTap: change_pages,
        ),
      ),
    );
  }
}
