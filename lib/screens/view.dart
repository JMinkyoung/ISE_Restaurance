import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPage extends StatelessWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;
  int countMenu = 0;
  String menuTemp;


  @override
  //Order record에서 데이터를 가져와서 메뉴이름에 따라 +1
  Widget ViewItem(DocumentSnapshot doc) {
    menuTemp = doc['MenuName'];
    FirebaseFirestore.instance
        .collection('OrderList')
        .where("MenuName", isEqualTo: menuTemp)
        .get()
        .then((QuerySnapshot ds) {
      ds.docs.forEach((doc) => getCount());
    });
    final vid = doc.data();
    return Container(
      child: Table(
        children: [
          TableRow(children: [
            Text('메뉴이름: ${vid['MenuName']}\n',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left),
            Padding(padding: EdgeInsets.all(0.0)),
            Text(countMenu.toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                textAlign: TextAlign.left),
          ])
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('판매 분석'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Menu')
                  //.where('MenuName', isEqualTo: id)
                      .snapshots() //OrderRecord값을 모조리 불러옴
                  ,
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

  getCount() {
    countMenu+=1;
    print(countMenu);
  }
}
