import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:restaurance/customAppBar.dart';
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
  String timeshow1;
  String timeshow2;
  String priceshow;
  int temp1 = 0;
  int temp2 = 0;
  int useTime = 0;
  int readyTime = 0;
  int totalprice = 0;
  int count = 0;
  int c = 0;

  @override
  Card buildItem(DocumentSnapshot doc) {
    final id = doc.data();

    Timestamp a = id['start'];
    Timestamp b = id['end'];
    temp1 = a.toDate().month;
    temp2 = a.toDate().day;
    if (b != null) {
      c = b.seconds - a.seconds;
    } else {
      c = 0;
    }

    if (temp1 == widget.month && temp2 == widget.day) {
      return Card(
          elevation: 10,
          color: Color(0xfffbffde),
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
                    Text(numberWithComma(id['total']) + '￦  ',
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
    } else {
      return Card();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: customAppBar_Staff(context, "소요시간 및 준비시간"),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Text(
              widget.month.toString() + '월' + widget.day.toString() + '일의 판매내역',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Padding(padding: EdgeInsets.all(5.0)),
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
              Text('결제금액',
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
                  FirebaseFirestore.instance
                      .collection('Order')
                      .get()
                      .then((QuerySnapshot ds) {
                    useTime = 0;
                    readyTime = 0;
                    count = 0;
                    ds.docs.forEach((doc) => avgmaker(doc));
                    setState(() {
                      timeshow1 = (useTime / (count * 60)).toStringAsFixed(0);
                      timeshow2 = (readyTime / count).toStringAsFixed(0);
                      priceshow = (totalprice / count).toStringAsFixed(0);
                    });
                    useTime = 0;
                    readyTime = 0;
                    totalprice = 0;
                    count = 0;
                  });

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
               Text((priceshow != null && priceshow != 'NaN')?priceshow+'￦':' ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text((timeshow1 != null && timeshow1 != 'NaN')?timeshow1+'분':' ',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.right),
              Text((timeshow2 != null && timeshow2 != 'NaN')?timeshow2+'분':' ',
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
    );
  }

  void avgmaker(DocumentSnapshot doc) async {
    Timestamp a = doc.data()['start'];
    temp1 = a.toDate().month;
    temp2 = a.toDate().day;
    Timestamp b = doc.data()['end'];
    int d = doc.data()['total'];
    if (b != null) {
      c = b.seconds - a.seconds;
    } else {
      c = 0;
    }
    if (temp1 == widget.month && temp2 == widget.day) {
      totalprice += d;
      useTime += c;
      readyTime += doc.data()['wait'];
      count++;
    }
  }
}

String numberWithComma(int param) {
  return new NumberFormat('###,###,###,###').format(param).replaceAll(' ', '');
}
