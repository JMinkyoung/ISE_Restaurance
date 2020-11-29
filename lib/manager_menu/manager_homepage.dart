import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurance/customAppBar.dart';
import 'package:restaurance/login_service/authentication_service.dart';
import 'package:restaurance/manager_menu/staff_manage.dart';
import 'package:restaurance/manager_menu/MenuManage.dart';
import 'package:restaurance/manager_menu/IngredientMange.dart';
import 'package:restaurance/screens/analysis.dart';

class ManagerHome extends StatelessWidget {
  static const double buttonHeight = 400;
  static const double buttonWidth = 250;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: customAppBar_Manag(context, ""),
      body: Stack(children: [
        Positioned(
          top: 40,
          left: 100,
          child: Container(
            child: const Text('Manager Menu',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown)),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StaffManage()),
                  );
                },
                elevation: 10,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: buttonHeight,
                  width: buttonWidth,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFFFD180),
                          Color(0xFFFFE0B2),
                          Color(0xFFFFD180),
                        ],
                      ),
                    ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: const Text('직원 관리',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
                  ),
                ),
              ),
              const SizedBox(width: 25.0),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuManage()),
                  );
                },
                elevation: 10,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: buttonHeight,
                  width: buttonWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFFFFD180),
                        Color(0xFFFFE0B2),
                        Color(0xFFFFD180),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: const Text('메뉴 관리',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
                  ),
                ),
              ),
              const SizedBox(width: 25.0),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IngredientMange()),
                  );
                },
                elevation: 10,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: buttonHeight,
                  width: buttonWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFFFFD180),
                        Color(0xFFFFE0B2),
                        Color(0xFFFFD180),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: const Text('식자재 재고 관리',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
                  ),
                ),
              ),
              const SizedBox(width: 25.0,),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewPage()),
                  );
                },
                elevation: 10,
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: buttonHeight,
                  width: buttonWidth,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFFFFD180),
                        Color(0xFFFFE0B2),
                        Color(0xFFFFD180),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: const Text('판매 분석',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
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
              color: Colors.yellow[100],
              elevation: 0,
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text(
                'Sign out',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
