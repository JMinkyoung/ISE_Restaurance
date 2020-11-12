import 'file:///C:/Users/KyewonPark/AndroidStudioProjects/restaurance/lib/login_service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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