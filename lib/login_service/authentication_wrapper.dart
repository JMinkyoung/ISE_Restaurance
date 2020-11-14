import 'package:restaurance/manager_menu/manager_homepage.dart';
import 'package:restaurance/staff_homepage.dart';
import 'package:restaurance/login_service/sign_in_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(firebaseUser.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final userdata = snapshot.data.data();
            if (userdata['role'] == 'Manager') {
              return ManagerHome();
            } else {
              return StaffHomePage(); //staffpage
            }
          } else {
            return Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    }
    return SignInPage();
  }
}
