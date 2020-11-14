import 'package:restaurance/login_service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurance/screens/home.dart';

class StaffHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Staff HOME"),
            RaisedButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => checkTime()),);
              },
              child: Text("check Time"),
            ),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}