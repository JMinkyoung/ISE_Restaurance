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
  String menuName;
  String menuPrice;
  String menuType;
  String dbid;

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
                    child: Text('메뉴삭제', style: TextStyle(color: Colors.white)),
                    onPressed: () {
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          preferredSize: null,
        ),
        backgroundColor: Colors.deepPurple,
        leading: Image.asset(
          'image/tray.png',
          height: 200,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            //buildTextFormField()
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
              /*RaisedButton(
                onPressed: dbid != null ? readMenu : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.deepPurple,
                child: Text("메뉴읽기",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),*/
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
    );
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
  }

  void readMenu() async {
    DocumentSnapshot snapshot = await db.collection("Menu").doc(dbid).get();
    print(snapshot['MenuName']);
    print(snapshot['MenuPrice']);
  }

  void uppdateMenu(DocumentSnapshot doc) async {}

  void deleteMenu(DocumentSnapshot doc) async {
    await db.collection("Menu").doc(doc.id).delete();
    setState(() => dbid = null);
  }
}
