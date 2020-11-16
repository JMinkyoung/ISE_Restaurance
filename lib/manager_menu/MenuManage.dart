import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuManage extends StatefulWidget {
  @override
  MenuManageState createState() {
    return MenuManageState();
  }
}

class MenuManageState extends State<MenuManage> {
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final editformkey = GlobalKey<FormState>();
  String menuName;
  String menuPrice;
  String menuType;
  String dbid;
  // textFormField 지우는 컨트롤러
  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();
  final TextEditingController _clearController3 = new TextEditingController();

  Card buildItem(DocumentSnapshot doc) {
    final menudata = doc.data();
    return Card(
      color: Colors.deepPurpleAccent,
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
              '메뉴: ${menudata['MenuName']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '가격: ${menudata['MenuPrice']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '카테고리: ${menudata['MenuType']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(width: 8),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.deepPurple,
                  child: Text('메뉴수정', style: TextStyle(color: Colors.white)),
                  onPressed: () => menuEditingDisplay(context),
                ),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.deepPurple,
                    child: Text('메뉴삭제', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      //메뉴 삭제시 삭제여부 확인 팝업창
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
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
        appBar: AppBar(
          title: Text("Restaurance",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
          bottom: PreferredSize(
            child: Text(
              "메뉴관리",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            preferredSize: null,
          ),
          backgroundColor: Colors.deepPurple,
          leading: Image.asset(
            'image/tray.png',
            height: 200,
          ),
        ),
        body: GestureDetector(
          onTap: () {
            //화면 다른부분 누르면 올라와있던 키보드 사라짐
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            padding: EdgeInsets.all(8),
            children: <Widget>[
              Form(
                key: _formKey,
                //buildTextFormField()
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      controller: _clearController,
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
                    new TextFormField(
                      controller: _clearController2,
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
                    new TextFormField(
                      controller: _clearController3,
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
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: addMenu,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.deepPurple,
                    child: Text("메뉴추가",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
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

  void addMenu() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection("Menu").add({
        'MenuName': '$menuName',
        'MenuPrice': '$menuPrice',
        'MenuType': '$menuType',
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

  void uppdateMenu(DocumentSnapshot doc) async {
    if (editformkey.currentState.validate()) {
      editformkey.currentState.save();
      db.collection("Menu").doc(doc.id).update({
        'MenuName': '$menuName',
        'MenuPrice': '$menuPrice',
        'MenuType': '$menuType',
      });
    }
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

  //메뉴 수정을 위해 팝업창에 TextField 생성하는 부분 (아직미완)
  menuEditingDisplay(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            key: editformkey,
            title: Text('메뉴수정'),
            content: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new TextFormField(
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
                  new TextFormField(
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
                  new TextFormField(
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
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('확인'),
                onPressed: () {
                  //uppdateMenu(doc),
                  Navigator.of(context).pop();
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
        });
  }
}
