import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  final _updateKey = GlobalKey<FormState>();

  String name, email, password;
  String name_up, email_up, password_up; //update용 변수
  // textFormField 지우는 컨트롤러
  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();
  final TextEditingController _clearController3 = new TextEditingController();
  //snapshot 받아서 현재 있는 직원들을 카드로 보여주는 위젯
  //목록으로 만드는것은 위젯 밖에서 한다.
  Card buildItem(DocumentSnapshot doc) {
    final userdata = doc.data();
    return Card(
      elevation: 10,
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
                FlatButton(
                  onPressed: () => {},
                  child: Text('근무기록'),
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => showUpdateData(doc),
                  child: Text('수정'),
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => showDeleteAlertDialog(doc),
                  child: Text('삭제'),
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
        backgroundColor: Colors.yellow[100],
        appBar: customAppBar_Manag(context, "직원관리"),
        body: GestureDetector(
          //화면 다른부분 누르면 올라와있던 키보드 사라짐
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
                          fillColor: Colors.white,
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
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (value) => name = value,
                      ),
                      TextFormField(
                        controller: _clearController3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "password",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                        },
                        onSaved: (value) => password = value,
                      ),
                    ],
                  )),
              RaisedButton(
                onPressed: () => {
                  showCreateAlertDialog(),
                  FocusScope.of(context)
                      .requestFocus(new FocusNode()) //create시 올라와있던 키보드 사라짐
                }, //store Data,
                color: Colors.yellow[300],
                child: Text('Create', style: TextStyle(color: Colors.black)),
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

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('users').doc(id).get();
    print(snapshot['name']);
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('users').doc(doc.id).delete();
    setState(() => id = null);
  }

  //내용 업데이트
  void updateData(doc) async {
    //if (key.currentState.validate())인식이 안되어서 삭제하였음
    _updateKey.currentState.save();
    await db.collection("users").doc(doc.id).update({
      'email': '$email_up',
      'name': '$name_up',
    });
  }
  //업데이트 위해 작성 form 보여줌
  Future<void> showUpdateData(doc) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
                key: _updateKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "email",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        } else return'';
                      },
                      onSaved: (value) => email_up = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "name",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }else return'';
                      },
                      onSaved: (value) => name_up = value,
                    ),
                  ],
                )),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () => {
                updateData(doc),
                Navigator.of(context).pop(),
              },
            ),
            new FlatButton(
              child: new Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //delete하기 전 정말 지울건지 물어보는 팝업 창.
  void showDeleteAlertDialog(doc) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete?"),
          actions: [
            FlatButton(
                child: Text("확인"),
                onPressed: () => {
                      deleteData(doc),
                      Navigator.pop(context),
                    }),
            FlatButton(
              child: Text("취소"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  //데이터 저장
  void storeData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //계정 생성도 동시에 함
      register(email,password);
      //firestore에 사용자 내용 추가
      DocumentReference ref = await db.collection("users").add({
        'email': '$email',
        'name': '$name',
        'role': 'Staff',
      });
      setState(() => id = ref.id);
      print(ref.id);
    }
  }

  //계정 생성시 auto login막기 위해 만든 함수
  static Future<UserCredential> register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

    await app.delete();
    return Future.sync(() => userCredential);
  }

  //create하기 전 정말 할건지 물어보는 팝업 창.
  void showCreateAlertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create?"),
          actions: [
            FlatButton(
              child: Text("확인"),
              onPressed: () => {
                storeData(),
                //남아있는 텍스트필드 지움
                _clearController.clear(),
                _clearController2.clear(),
                _clearController3.clear(),
                Navigator.pop(context),
              },
            ),
            FlatButton(
              child: Text("취소"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }



}

