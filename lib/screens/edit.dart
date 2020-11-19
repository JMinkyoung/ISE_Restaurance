import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:restaurance/screens/home.dart';
import 'dart:convert';
import 'memo.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  String id;
  final db = FirebaseFirestore.instance;

  int price;
  int createTime;
  int prepTime;

  @override
  //값 입력 텍스트필드
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('test'), actions: <Widget>[
        /*  IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),*/
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveDB,
          ),
        ]),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String price) {
                  this.price = int.parse(price);
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                //obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '가격',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                onChanged: (String createTime) {
                  this.createTime = int.parse(createTime);
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '소요시간',
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              TextField(
                onChanged: (String prepTime) {
                  this.prepTime = int.parse(prepTime);
                },
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '준비시간',
                ),
              ),
            ],
          ),
        ));
  }

  void saveDB() async {
    var simpleTime = DateTime.now().month.toString()
        +'-'+DateTime.now().day.toString()
        +' '+(DateTime.now().hour+9>24 ? DateTime.now().hour-15: DateTime.now().hour+9).toString()
        +':'+(DateTime.now().minute<10 ? 0: '').toString()+DateTime.now().minute.toString();
    //시간 표시 변수
    var fido = Memo(
      id: Str2Sha512(DateTime.now().toString()),
      enterTime: simpleTime,
      price: this.price,
      createTime:this.createTime,
      prepTime: this.prepTime,
    );
    DocumentReference ref = await db.collection("Order").add(fido.toMap());

    setState(() => id = ref.id);
    print(ref.id);
    Navigator.pop(context);
  }

  String Str2Sha512(String text) {
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
