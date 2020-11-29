import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurance/customAppBar.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  int rank = 0;

  // ignore: non_constant_identifier_names
  /*  Widget ViewItem(DocumentSnapshot doc) {
    final vid = doc.data();
    rank++;
    return Container(
      child: Table(
        children: [
          TableRow(children: [
            Text('판매순위:' + rank.toString() + '위',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left),
            Padding(padding: EdgeInsets.all(0.0)),
            Text('메뉴이름: ${vid['menuName']}\n',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left),
            Padding(padding: EdgeInsets.all(0.0)),
            Text('${vid['count']}개 판매되었습니다.',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left),
          ])
        ],
      ),
    );
  } */
  // ignore: non_constant_identifier_names
  SizedBox ViewItem(DocumentSnapshot doc) {
    final vid = doc.data();
    rank++;
    return SizedBox(
      width: 1300.0,
      height: 150.0,
      child: Card(
        elevation: 10,
        color: Color(0xfffbffde),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '<' + rank.toString() + '위>',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '메뉴이름: ${vid['menuName']}\n',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '총 ${vid['count']}개 판매되었습니다.',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: customAppBar_Manag(context, "판매 분석"),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('OrderRow')
                      .orderBy('count', descending: true)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.docs
                              .map((doc) => ViewItem(doc))
                              .toList());
                    } else {
                      return SizedBox();
                    }
                  }),
            ],
          ),
        ));
  }
}
