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
                  onPressed: () => deleteMenu(doc),
                  child: Text('메뉴삭제', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  //메뉴 이름, 가격, 카테고리 별로 다시 추가해야함
  TextFormField buildTextFormField() {
    return TextFormField(
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
            child: buildTextFormField(),
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
              RaisedButton(
                onPressed: dbid != null ? readMenu : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.deepPurple,
                child: Text("메뉴읽기",
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
    );
  }

  void addMenu() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection("Menu").add({
        'MenuName': '$menuName',
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
