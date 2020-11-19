import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientMange extends StatefulWidget {
  @override
  IngredientMangeState createState() {
    return IngredientMangeState();
  }
}

class IngredientMangeState extends State<IngredientMange> {
  final db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final editformkey = GlobalKey<FormState>();

  String ingredientName;
  String ingredientQuantity;
  String dbid;

  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();
  final TextEditingController _clearController3 = new TextEditingController();

  Card buildItem(DocumentSnapshot doc) {
    final ingredientData = doc.data();
    return Card(
      color: Colors.deepPurpleAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'image/ingredient.jpg',
              height: 70,
            ),
            Text(
              '자재명: ${ingredientData['IngredientName']}',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              '수량: ${ingredientData['IngredientQuantity']}',
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
                    child: Text('수정', style: TextStyle(color: Colors.white)),

                    //수정부분 고쳐야함
                    onPressed: () => ingredientEditingDisplay(context, doc)),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.deepPurple,
                    child: Text('삭제', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('식자재 삭제'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('식자재를 삭제하시겠습니까?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    deleteIngredient(doc);
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
              "식자재 관리",
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
                key: formKey,
                //buildTextFormField()
                child: new Column(
                  children: <Widget>[
                    new TextFormField(
                      controller: _clearController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '식자재1',
                        fillColor: Colors.grey[300],
                        labelText: '식자재이름',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => ingredientName = value,
                    ),
                    new TextFormField(
                      controller: _clearController2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '10개',
                        fillColor: Colors.grey[300],
                        labelText: '수량',
                      ),
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                      onSaved: (value) => ingredientQuantity = value,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: addIngredient,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.deepPurple,
                    child: Text("식자재추가",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: db.collection("Ingredient").snapshots(),
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

  //새로운 식자재 추가 함수
  void addIngredient() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      DocumentReference ref = await db.collection("Ingredient").add({
        'IngredientName': '$ingredientName',
        'IngredientQuantity': '$ingredientQuantity',
      });
      setState(() => dbid = ref.id);
      print(ref.id);
    }
  }

  //식자재 삭제 함수
  void deleteIngredient(DocumentSnapshot doc) async {
    await db.collection("Ingredient").doc(doc.id).delete();
    setState(() => dbid = null);
  }

  //식자재 수정 함수
  void uppdateIngredient(DocumentSnapshot doc) async {
    print(ingredientName);
    if (editformkey.currentState.validate()) {
      editformkey.currentState.save();
      db.collection("Ingredient").doc(doc.id).update({
        'IngredientName': '$ingredientName',
        'IngredientQuantity': '$ingredientQuantity',
      });
    }
  }

  //수정할때 띄우는 팝업창
  ingredientEditingDisplay(BuildContext context, DocumentSnapshot doc) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            key: editformkey,
            title: Text('식자재 수정'),
            content: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '자재명1',
                      fillColor: Colors.grey[300],
                      labelText: '자재명',
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => ingredientName = value,
                  ),
                  new TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '10개',
                      fillColor: Colors.grey[300],
                      labelText: '수량',
                    ),
                    // ignore: missing_return
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                    },
                    onSaved: (value) => ingredientQuantity = value,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('확인'),
                onPressed: () {
                  print(ingredientName);
                  uppdateIngredient(doc);
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
