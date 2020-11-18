import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurance/customAppBar.dart';

/// 직원관리 페이지
/// 직원 목록 불러와 카드 형태로 출력하고, 생성 및 삭제를 진행할 수 있다.

class StaffManage extends StatefulWidget {
  @override
  StaffManageState createState() {
    return StaffManageState();
  }
}

class StaffManageState extends State<StaffManage> {
  //createStaff의 form작성에 필요한 변수 선언
  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name, email;
  // textFormField 지우는 컨트롤러
  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();

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
            Row(
              //오른쪽 밑에 누르면 직원 데이터를 삭제하는 버튼을 만든다.
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => showDeleteAlertDialog(context, doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //createStaff에 필요한 TextForm만드는 함수
  buildTextFormField(String text, thing) {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: text,
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => thing = value,
    );
  }

  ///---------------------------------------------------------build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          //title: Text('직원관리'),
//        ),
        appBar: customAppBar_Manag(context),
        body: GestureDetector( //화면 다른부분 누르면 올라와있던 키보드 사라짐
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              //직원 생성하는 버튼
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _clearController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "email",
                          fillColor: Colors.grey[300],
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (value) => email = value,
                      ),
                      TextFormField(
                        controller: _clearController2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "name",
                          fillColor: Colors.grey[300],
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (value) => name = value,
                      ),
                    ],
                  )),
              RaisedButton(
                onPressed: () => {
                  showCreateAlertDialog(context),
                  FocusScope.of(context).requestFocus(new FocusNode()) //create시 올라와있던 키보드 사라짐
                }, //store Data,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),

              //직원 내역 카드목록으로 출력
              StreamBuilder<QuerySnapshot>(
                stream: db.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        children: snapshot.data.docs
                            .map((doc) => buildItem(doc))
                            .toList());
                  } else {
                    return SizedBox();
                  }
                },
              )
            ],
          ),
        ));
  }

  ///------------------------------------------------------

  void storeData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection("users").add({
        'email': '$email',
        'name': '$name',
        'role': 'Staff',
      });
      setState(() => id = ref.id);
      print(ref.id);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('users').doc(id).get();
    print(snapshot['name']);
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('users').doc(doc.id).delete();
    setState(() => id = null);
  }

  //delete하기 전 정말 지울건지 물어보는 팝업 창.
  void showDeleteAlertDialog(BuildContext context, doc) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete?"),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
                child: Text("Yes"),
                onPressed: () => {
                      deleteData(doc),
                      Navigator.pop(context),
                    }),
          ],
        );
      },
    );
  }

  //create하기 전 정말 할건지 물어보는 팝업 창.
  void showCreateAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create?"),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () => {
                storeData(),
                //남아있는 텍스트필드 지움
                _clearController.clear(),
                _clearController2.clear(),
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }
}
