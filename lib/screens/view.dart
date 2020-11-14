import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPage extends StatelessWidget {
  ViewPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  //나중에 수정할 예정 넣을 내용이 없음
  Widget ViewItem(DocumentSnapshot doc) {
    final vid = doc.data();
    return Container(
      child: Column(
        children: [
          Text('입장시간: ${vid['enterTime']}\n',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.left),
          Text('예상금액${vid['price']}￦\n',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.left),
          Text('소요시간${vid['createTime']}분\n',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.left),
          Text('준비시간${vid['prepTime']}분\n',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.left),
          Padding(padding: EdgeInsets.all(0.0)),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('상세보기'), actions: <Widget>[
          /*  IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),*/
        ]),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Order')
                      .where('id', isEqualTo: id)
                      .snapshots() //search id로 관련 db찾기
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
}
