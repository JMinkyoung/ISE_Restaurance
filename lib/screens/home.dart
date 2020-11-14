import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view.dart';
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

  @override
  Card buildItem(DocumentSnapshot doc) {
    final id = doc.data();
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
                  SizedBox(
                      height: 35,
                      child: RaisedButton(
                        child: Text('상세보기',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Colors.deepPurple,
                        onPressed: () {
                          ident = '${id['id']}';
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ViewPage(id: ident)));
                        },
                        //goto Details.dart
                      )),
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
              SizedBox(),
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
              Text('구현x',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text('구현x',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Padding(padding: EdgeInsets.all(0.0)),
              SizedBox(),
            ])
          ]),
        ],
      ),

      appBar: AppBar(
        
      ),

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
