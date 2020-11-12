import 'package:restaurance/manager_menu/staff_manage.dart';
import 'package:restaurance/manager_menu/manager_homepage.dart';
import 'package:flutter/material.dart';


class ManagerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      // "/"으로 named route와 함께 시작. (MainPage 위젯에서 시작)
      initialRoute: '/',
      routes: {
        /// "/" Route로 이동하면, MainPage 위젯을 생성.
        '/': (context) => ManagerHome(),
        'manager_menu/staff_manage': (context) => StaffManage(),
//        'manager_menu/staff_manage': (context) => function(),
      },
      title: 'Restaurance',
    );
  }
}

//Scaffold(
//body: Center(
//child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
//children: [
//Text("ManagerHomePage"),
//RaisedButton(
//onPressed: () {
//StaffManage();
//},
//child: Text("Staff Manage"),
//),
//const SizedBox(height: 100.0),
//RaisedButton(
//onPressed: () {
//context.read<AuthenticationService>().signOut();
//},
//child: Text("Sign out"),
//),
//],
//),
//),
//);