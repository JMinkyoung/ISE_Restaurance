import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:restaurance/customAppBar.dart';
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

  int month;
  int day;
  int prepTime;
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();


  @override
  //값 입력 텍스트필드
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: customAppBar_Manag(context, "소요시간 및 준비시간"),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (String month) {
                this.month = int.parse(month);
              },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.number,
              maxLines: null,
              //obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '월',
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              controller: _controller2,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (String day) {
                this.day = int.parse(day);
              },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.number,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '일',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(checkday(month, day)) {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) =>
                checkTime(month: this.month, day: this.day)));
          }
          else
            {
              showDeleteAlertDialog();
            }
        },
        backgroundColor: Colors.yellow[200],
        tooltip: '검색하기',
        label: Text('Search', style: TextStyle(fontSize: 25, color:Colors.black) ),
        icon: Icon(Icons.search, color:Colors.black),
      ),
    );
  }

  void showDeleteAlertDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("잘못된 입력입니다."),
          actions: [
            FlatButton(
                child: Text("확인"),
                onPressed: () =>
                {
                  _controller.clear(),
                  _controller2.clear(),
                  super.dispose(),
                  Navigator.pop(context),
                }
                ),
          ],
        );
      },
    );
  }

  /*void saveDB() async {
    var simpleTime = DateTime.now().month.toString()
        +'-'+DateTime.now().day.toString()
        +' '+(DateTime.now().hour+9>24 ? DateTime.now().hour-15: DateTime.now().hour+9).toString()
        +':'+(DateTime.now().minute<10 ? 0: '').toString()+DateTime.now().minute.toString();
    //시간 표시 변수
    var fido = Memo(
      id: Str2Sha512(DateTime.now().toString()),
      enterTime: simpleTime,


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
  }*/
}

bool checkday(int month, int day) {
  if (month == 2 && day >= 1 && day <= 28)
    return true;
  else if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 ||
      month == 10 || month == 12) {
    if (day >= 1 && day <= 31) {
      return true;
    }
    else
    {
      return false;
    }
  }
  else if(month == 4 || month == 6 || month == 9 || month == 11 ) {
    if (day >= 1 && day <= 30) {
      return true;
    }
    else
      {
        return false;
      }
  }else{
    return false;
  }
}
