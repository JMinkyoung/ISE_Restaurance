import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 직원관리 페이지
/// 직원 목록 불러와 카드 형태로 출력하고, 생성 및 삭제를 진행할 수 있다.

class StaffManage extends StatefulWidget {
  @override
  StaffManageState createState() {
    return StaffManageState();
  }
}

class StaffManageState extends State<StaffManage> {
  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  //snapshot 받아서 현재 있는 직원들을 카드로 보여주는 위젯
  //목록으로 만드는것은 위젯 밖에서 한다.
  Card buildItem(DocumentSnapshot doc) {
    final userdata = doc.data();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'email: ${userdata['email']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'name: ${userdata['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'role: ${userdata['role']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 12),
            Row( //오른쪽 밑에 누르면 직원 데이터를 삭제하는 버튼을 만든다.
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('직원관리'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          ///TODO : CREATE버튼 누르면 직원 생성하는 페이지 따로 출력
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
              RaisedButton(
                onPressed: id != null ? readData : null,
                child: Text('Read', style: TextStyle(color: Colors.white)),
                color: Colors.blue,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(children: snapshot.data.docs.map((doc) => buildItem(doc)).toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('users').add({'name': '$name',});
      setState(() => id = ref.id);
      print(ref.id);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('users').doc(id).get();
    print(snapshot['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db.collection('users').doc(doc.id).update({'todo': 'please'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('users').doc(doc.id).delete();
    setState(() => id = null);
  }
}
