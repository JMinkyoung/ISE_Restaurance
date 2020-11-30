import 'package:flutter/material.dart';
import 'package:restaurance/OrderScreens/OrderRoute.dart';
import 'package:restaurance/OrderScreens/TableRoute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:restaurance/login_service/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:restaurance/screens/home.dart';
import 'package:restaurance/customAppBar.dart';

class SelectOrderType extends StatelessWidget {
  static const double buttonHeight = 60;
  static const double buttonWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: customAppBar_Manag(context, ""),
      body: Stack(children: [
        Positioned(
          top: 40,
          left: 130,
          child: Container(
            child: const Text('주문 유형 선택',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderRoute(table: 0)),
                  );
                },
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
                    child: const Text('포장 주문',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown)),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TableRoute()),
                  );
                },
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
                    child: const Text('테이블 주문',
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
      ]),
    );
  }
}
