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
  int countMenu = 0;
  int temp = 0;
  final db = FirebaseFirestore.instance;

  SizedBox ViewItem(DocumentSnapshot doc) {
    final vid = doc.data();
    rank++;
    count(doc);
    return SizedBox(
      width: 500.0,
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
                '메뉴이름: ${vid['MenuName']}\n',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '총 ${vid['Count']}개 판매되었습니다.',
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
                      .collection('Menu')
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

  Future<void> count(DocumentSnapshot doc) async {
    FirebaseFirestore.instance
        .collection('OrderRow')
        .where('menuName', isEqualTo: doc.data()['MenuName'])
        .get().then((QuerySnapshot ds) {
      ds.docs.forEach((doc2) => counting(doc2));
      countMenu = temp;
      db.collection("Menu").doc(doc.id).update({
        'MenuName': doc.data()['MenuName'],
        'MenuPrice': doc.data()['MenuPrice'],
        'MenuTime': doc.data()['MenuTime'],
        'MenuType': doc.data()['MenuType'],
        'Count': '$countMenu',
      });
      temp = 0;
        });
    }


    int counting(DocumentSnapshot doc)
    {
      temp += doc.data()['count'];
    }
  }


