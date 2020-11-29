import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit.dart';

class checkTime extends StatefulWidget {
  checkTime({Key key, this.month, this.day}) : super(key: key);

  final int month;
  final int day;

  @override
  _checkTimeState createState() => _checkTimeState();
}

class _checkTimeState extends State<checkTime> {
  final db = FirebaseFirestore.instance;
  String ident;
  int temp1 = 0;
  int temp2 = 0;
  int useTime = 0;
  int readyTime = 0;
  int count = 0;


  @override
  Card buildItem(DocumentSnapshot doc) {
    int c = 0;
    final id = doc.data();

    Timestamp a = id['start'];
    Timestamp b = id['end'];
    temp1 = a.toDate()
        .month;
    temp2 = a.toDate()
        .day;
    if (b != null) {
      print(a);
      print(b);
      c = b.seconds - a.seconds;
      print(c / 60);
    }

    useTime += c;
    readyTime += id['wait'];

    count++;

      return Card(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Table(children: [
                TableRow(
                  children: [
                    Text(
                      '${a.toDate()}  ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text('${id['total']}￦  ',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.right),
                    Text('${(c / 60).toStringAsFixed(0)}분',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.right),
                    Text('${id['wait']}분',
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
              Text((useTime / (60*count)).toStringAsFixed(0) + '분',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text((readyTime / count).toStringAsFixed(0) + '분',
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
