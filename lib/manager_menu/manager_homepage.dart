import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurance/customAppBar.dart';
import 'package:restaurance/login_service/authentication_service.dart';
import 'package:restaurance/manager_menu/staff_manage.dart';
import 'package:restaurance/manager_menu/MenuManage.dart';

class ManagerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar_Manag(context),
      body: Stack(
        children : [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ManagerHomePage"),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => StaffManage()),);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 70,
                    width: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: const Text(
                          '직원 관리',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => MenuManage()),);
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    height: 70,
                    width: 200,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: const Text(
                          '메뉴 관리',
                          style: TextStyle(fontSize: 20)
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 20),
              child: RaisedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
                child: Text("Sign out"),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
