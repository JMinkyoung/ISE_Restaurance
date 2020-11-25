import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurance/customAppBar.dart';

class MenuManage extends StatefulWidget {
  @override
  MenuManageState createState() {
    return MenuManageState();
  }
}

class MenuManageState extends State<MenuManage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _editkey = GlobalKey<FormState>();
  String menuName, menuPrice, menuType, dbid;
  String menuTime;
  // ignore: non_constant_identifier_names
  String menuName_edit, menuPrice_edit, menuType_edit;
  String menuTime_edit;

  // textFormField 지우는 컨트롤러
  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();
  final TextEditingController _clearController3 = new TextEditingController();

  Card buildItem(DocumentSnapshot doc) {
    final menudata = doc.data();
    return Card(
      elevation: 10,
      color: Colors.orangeAccent[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'image/food.jpg',
              height: 70,
            ),
            Text(
              '메뉴이름: ${menudata['MenuName']}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '가격: ${menudata['MenuPrice']} 원',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '카테고리: ${menudata['MenuType']}',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '소요시간: ${menudata['MenuTime']} 분',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.orange[300],
                  child: Text('메뉴수정', style: TextStyle(color: Colors.white)),
                  onPressed: () => menuEditingDisplay(doc),
                ),
                SizedBox(width: 8),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.orange[300],
                    child: Text('메뉴삭제', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            //삭제 요청시 확인 팝업창
                            return AlertDialog(
                              title: Text('메뉴 삭제'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('메뉴를 삭제하시겠습니까?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    deleteMenu(doc);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('네'),
                                ),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('아니요')),
                              ],
                            );
                          });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: customAppBar_Manag(context, "메뉴 관리"),
        body: GestureDetector(
          onTap: () {
            //화면 다른부분 누르면 올라와있던 키보드 사라짐
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: menuCreateDisplay,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.orange[200],
                    child: Text("메뉴추가",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection("Menu").snapshots(),
                // ignore: missing_return
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

  //-----------------------------DB 연동 관련 함수들------------------------------
  void addMenu() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection("Menu").add({
        'MenuName': '$menuName',
        'MenuPrice': '$menuPrice',
        'MenuType': '$menuType',
        'MenuTime': '$menuTime',
      });
      setState(() => dbid = ref.id);
      print(ref.id);
    }
    //남아있는 텍스트필드 지움
    _clearController.clear();
    _clearController2.clear();
    _clearController3.clear();
    //create시 올라와있던 키보드 사라짐
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void readMenu() async {
    DocumentSnapshot snapshot = await db.collection("Menu").doc(dbid).get();
    print(snapshot['MenuName']);
    print(snapshot['MenuPrice']);
  }

  void uppdateMenu(doc) async {
    _editkey.currentState.save();
    await db.collection("Menu").doc(doc.id).update({
      'MenuName': '$menuName_edit',
      'MenuPrice': '$menuPrice_edit',
      'MenuType': '$menuType_edit',
      'MenuTime': '$menuTime_edit',
    });

    //남아있는 텍스트필드 지움
    _clearController.clear();
    _clearController2.clear();
    _clearController3.clear();
    //create시 올라와있던 키보드 사라짐
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void deleteMenu(DocumentSnapshot doc) async {
    await db.collection("Menu").doc(doc.id).delete();
    setState(() => dbid = null);
  }

//---------------------------------------------------------------------------

  //메뉴 추가를 위한 텍스트 입력 팝업창
  Future<void> menuCreateDisplay() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '메뉴1',
                        fillColor: Colors.grey[300],
                        labelText: '메뉴이름',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuName = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '13000원',
                        fillColor: Colors.grey[300],
                        labelText: '가격',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuPrice = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '양식',
                        fillColor: Colors.grey[300],
                        labelText: '카테고리',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuType = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '10',
                        fillColor: Colors.grey[300],
                        labelText: '소요시간',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuTime = value,
                    ),
                  ],
                )),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () => {
                addMenu(),
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

  //메뉴 수정을 위한 텍스트 입력 팝업창
  Future<void> menuEditingDisplay(doc) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
                key: _editkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '메뉴1',
                        fillColor: Colors.grey[300],
                        labelText: '메뉴이름',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuName_edit = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '13000원',
                        fillColor: Colors.grey[300],
                        labelText: '가격',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuPrice_edit = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '양식',
                        fillColor: Colors.grey[300],
                        labelText: '카테고리',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuType_edit = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '10',
                        fillColor: Colors.grey[300],
                        labelText: '소요시간',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => menuTime_edit = value,
                    ),
                  ],
                )),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () => {
                uppdateMenu(doc),
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
}
