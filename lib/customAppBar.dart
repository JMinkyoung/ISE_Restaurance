import 'package:flutter/material.dart';
import 'package:restaurance/manager_menu/manager_homepage.dart';
import 'package:restaurance/staff_homepage.dart';

//전용 앱바
//로고 누르면 메인페이지로 가도록 설정함
Widget customAppBar_Manag(context){
  return AppBar(
    leading: Image.asset(
      'image/tray.png',
      height: 200,
    ),
    title: RaisedButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ManagerHome(),
            ));
      },
      color: Colors.yellow[100],
      elevation: 0,
      child: Text(
        "Restaurance",
        style: TextStyle(fontFamily: 'BethEllen', color: Colors.brown[800], fontSize: 25.0),
      ),
    ),
  );
}

Widget customAppBar_Staff(context){
  return AppBar(
    title: RaisedButton(
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StaffHomePage(),
            ));
      },
      color: Colors.yellow[100],
      elevation: 0,
      child: Text(
        "Restaurance",
        style: TextStyle(fontFamily: 'BethEllen', color: Colors.brown[800], fontSize: 20.0),
      ),
    ),
  );
}