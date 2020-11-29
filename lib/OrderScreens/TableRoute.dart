import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:restaurance/OrderScreens/OrderRoute.dart';

class TableRoute extends StatefulWidget {
  TableRoute({Key key}) : super(key: key);

  @override
  _TableRouteState createState() => _TableRouteState();
}

class _TableRouteState extends State<TableRoute> {
  Widget _buildtables() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Order")
          .where("completed", isEqualTo: false).where("tableNum", isGreaterThan: 0).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(
            child: Text("주문이 진행중인 테이블이 없습니다."),
          );
        }
        List<DocumentSnapshot> documents = snapshot.data.documents;
        return ListView(
          padding:EdgeInsets.only(top: 20.0),
          children: documents.map((eachDocument) => _buildRow(eachDocument)).toList(),
        );
      },
    );
  }

  Widget _buildRow(DocumentSnapshot snapshot)
  {
    return Card(
      child: ListTile(
        title: Column(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topLeft,
              child: Text(snapshot.data()["tableNum"].toString() + "번 테이블"),
            ),
            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("OrderRow")
                    .where("orderId", isEqualTo: snapshot.id).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text("");
                  }
                  List<DocumentSnapshot> documents = snapshot.data.documents;
                  return Column(
                    children: documents.map((eachDocument) => _buildOrderRow(eachDocument)).toList(),
                  );
                },
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomRight,
              child: Text(snapshot.data()["total"].toString() + "원"),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderRoute(table: snapshot.data()["tableNum"], orderId: snapshot.id)),
          );
        },
      ),
    );
  }

  Widget _buildOrderRow(DocumentSnapshot snapshot)
  {
    return Text(snapshot.data()["menuName"].toString() + " " + snapshot.data()["count"].toString() + "개");
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('테이블 목록'),
      ),
      body: _buildtables(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async  {
          var data = new List<String>();
          for (int i = 1; i < 21; ++i)
            data.add(i.toString());

          QuerySnapshot snapshots = await FirebaseFirestore.instance
              .collection("Order")
              .where("completed", isEqualTo: false).where("tableNum", isGreaterThan: 0).get();

          for (QueryDocumentSnapshot snapshot in snapshots.docs)
          {
            if (data.contains(snapshot.data()["tableNum"].toString()))
              data.remove(snapshot.data()["tableNum"].toString());
          }

          showMaterialScrollPicker(
            context: context,
            title: "주문을 추가할 테이블을 선택하세요",
            items: data,
            onChanged: (selected) {
              FirebaseFirestore.instance.collection("Order").add(
                  { 'completed': false, 'tableNum': int.parse(selected.toString()), 'start': DateTime.now(), 'total': 0, 'wait': 0 }
              );
            },
          );
        },
        tooltip: '테이블 추가',
        child: Icon(Icons.add),
      ),
    );
  }
}