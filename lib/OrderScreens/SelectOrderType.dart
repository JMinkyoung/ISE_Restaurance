import 'package:flutter/material.dart';
import 'package:restaurance/OrderScreens/OrderRoute.dart';
import 'package:restaurance/OrderScreens/TableRoute.dart';
import 'package:firebase_core/firebase_core.dart';

class SelectOrderType extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: '주문 유형 선택',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("에러 발생. 재실행해주세요.");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return SelectOrder();
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class SelectOrder extends StatefulWidget {
  SelectOrder({Key key}) : super(key: key);

  @override
  _SelectOrderState createState() => _SelectOrderState();
}

class _SelectOrderState extends State<SelectOrder> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("주문 유형 선택"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child:RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderRoute(table: 0)),
                    );
                  },
                  child: Text(
                    "포장 주문",
                  ),
                )
            ),
            Expanded(
                child:RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TableRoute()),
                    );
                  },
                  child: Text(
                    "테이블 주문",
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
