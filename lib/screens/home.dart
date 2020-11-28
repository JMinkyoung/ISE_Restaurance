import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit.dart';

class checkTime extends StatefulWidget {
  checkTime({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _checkTimeState createState() => _checkTimeState();
}

class _checkTimeState extends State<checkTime> {
  final db = FirebaseFirestore.instance;
  String ident;
  int temp1 = 0;
  int temp2 = 0;
  int avgCreateTime = 0;
  int avgPrepTime = 0;
  int Count = 0;

  @override
  Card buildItem(DocumentSnapshot doc) {
    final id = doc.data();
    //관련 데이터 베이스 밀어야 오류 안남 원래 String으로 데이터 저장했는데 int로 저장되도록 바꿔서 생기는 오류
    temp1 = id['createTime'];
    temp2 = id['prepTime'];
    avgCreateTime += temp1;
    avgPrepTime += temp2;
    Count += 1;
    return Card(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Table(children: [
              TableRow(
                children: [
                  Text(
                    '${id['enterTime']}  ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('${id['price']}￦  ',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.right),
                  Text('${id['createTime']}분',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.right),
                  Text('${id['prepTime']}분',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.right),
                  Padding(padding: EdgeInsets.all(0.0)),
                ],
              ),
            ])));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Table(children: [
            TableRow(children: [
              Text(
                '입장시간',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text('예상금액',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text('소요시간',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text('준비시간',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Padding(padding: EdgeInsets.all(0.0)),
            ])
          ]),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection('Order').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data.docs
                          .map((doc) => buildItem(doc))
                          .toList());
                } else {
                  return SizedBox();
                }
              }),
          Table(children: [
            TableRow(children: [
              Text(
                '선택일자 평균',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(''),
              Text((avgCreateTime / Count).toStringAsFixed(0) + '분',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text((avgPrepTime / Count).toStringAsFixed(0) + '분',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Padding(padding: EdgeInsets.all(0.0)),
            ])
          ]),
        ],
      ),

      appBar: AppBar(),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => EditPage()));
        },
        backgroundColor: Colors.deepPurple,
        tooltip: '추가하려면 클릭',
        label: Text('ADD', style: TextStyle(fontSize: 25)),
        icon: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
