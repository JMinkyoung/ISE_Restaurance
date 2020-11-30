import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              onChanged: (String month) {
                this.month = int.parse(month);
              },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              //obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '월',
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            TextField(
              onChanged: (String day) {
                this.day = int.parse(day);
              },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.multiline,
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
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => checkTime(month:this.month,day: this.day)));
        },
        backgroundColor: Colors.yellow[200],
        tooltip: '검색하기',
        label: Text('Search', style: TextStyle(fontSize: 25, color:Colors.black) ),
        icon: Icon(Icons.search, color:Colors.black),
      ),
    );
  }
