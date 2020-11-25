import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurance/customAppBar.dart';

class PayTime extends StatefulWidget {
  final String userEm;

  const PayTime({Key key, this.userEm}) : super(key: key);

  @override
  _PayTimeState createState() => _PayTimeState();
}

class _PayTimeState extends State<PayTime> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: customAppBar_Manag(context, "메뉴 관리"),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              //화면 다른부분 누르면 올라와있던 키보드 사라짐
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
              padding: EdgeInsets.all(8),
              children: <Widget>[
                //Order컬렉션 안에 문서들을 받아 각각의 시간을 나타내는 함수 호출
                StreamBuilder<QuerySnapshot>(
                  stream: db.collection("Order").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                          children: snapshot.data.docs
                              .map((doc) => getTimeList(doc, widget.userEm))
                              .toList());
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  //카드형식으로 직원의 결제시각을 출력한다.
  Card getTimeList(DocumentSnapshot doc, String userEmail) {
    final orderData = doc.data();
    //다른 직원들은 제외하고 클릭한 직원의 이메일인 userEmail이 일치하는 직원만 출력한다.
    if(userEmail == orderData['useremail']){
      return Card(
        elevation: 10,
        color: Colors.orangeAccent[100],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '직원: ${orderData['useremail']}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '결제 시각: ${parseTime(orderData)}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }
    else return Card();
  }

  //TimeStamp를 정해진 format : yyyy-MM-dd hh:mm 으로 출력시키도록하는 함수.
  String parseTime(orderData){
    //orderData['end'] 에 해당하는 timeStamp를 받아 DateTime형식으로 바꾼다.
    DateTime dateTime = (orderData['end']).toDate();
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    var dateT = f.format(dateTime); //format에 적용시킨다.
    return dateT;
  }
}