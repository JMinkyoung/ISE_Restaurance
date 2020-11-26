import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurance/customAppBar.dart';

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

  String ingredientName, ingredientQuantity, dbid;
  String ingredientName_edit, ingredientQuantity_edit;

  final TextEditingController _clearController = new TextEditingController();
  final TextEditingController _clearController2 = new TextEditingController();
  final TextEditingController _clearController3 = new TextEditingController();

  Card buildItem(DocumentSnapshot doc) {
    final ingredientData = doc.data();
    return Card(
      elevation: 10,
      color: Color(0xfffbffde),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              '수량: ${ingredientData['IngredientQuantity']} 개',
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
                    color: Color(0xffffca69),
                    child: Text('수정', style: TextStyle(color: Colors.black)),
                    onPressed: () => ingredientEditDisplay(doc)),
                SizedBox(width: 8),
                FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Color(0xffffca69),
                    child: Text('삭제', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //삭제 요청시 확인 팝업창
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
        backgroundColor: Colors.yellow[100],
        appBar: customAppBar_Manag(context, "식재료 관리"),
        body: GestureDetector(
          onTap: () {
            //화면 다른부분 누르면 올라와있던 키보드 사라짐
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              padding: EdgeInsets.all(8),
              children: <Widget>[
                RaisedButton(
                  onPressed: ingredientCreateDisplay,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xffffca69),
                  child: Text("식자재추가",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
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
          ),
        ));
  }

//-----------------------------DB 연동 관련 함수들------------------------------

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
    if (editformkey.currentState.validate()) {
      editformkey.currentState.save();
      db.collection("Ingredient").doc(doc.id).update({
        'IngredientName': '$ingredientName_edit',
        'IngredientQuantity': '$ingredientQuantity_edit',
      });
    }
  }

//---------------------------------------------------------------------------

  //식자재 추가를 위한 텍스트 입력 팝업창
  Future<void> ingredientCreateDisplay() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                    TextFormField(
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
                )),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () => {
                addIngredient(),
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

  //식자재 추가를 위한 텍스트 입력 팝업창
  Future<void> ingredientEditDisplay(doc) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
                key: editformkey,
                child: Column(
                  children: [
                    TextFormField(
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
                      onSaved: (value) => ingredientName_edit = value,
                    ),
                    TextFormField(
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
                      onSaved: (value) => ingredientQuantity_edit = value,
                    ),
                  ],
                )),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('확인'),
              onPressed: () => {
                uppdateIngredient(doc),
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
