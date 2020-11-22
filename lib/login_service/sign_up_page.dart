import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  //각 항목에 해당하는 스트링을 받는 컨트롤러.
  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  //'user'컬렉션 지정
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  //유저 생성 후 name과 role까지 지정
  signupWithEmail(
      {String email, String password, String name, String role}) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user;
    await userCollection.doc(user.uid).set({
      'email': email,
      'name': _nameController.text,
      'role': radioButtonItem
    });

    return user;
  }

  //role고르는 radio버튼 위해 선언
  String radioButtonItem = 'Staff'; //초기값
  int id = 1;
  String get role => radioButtonItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.yellow[100],
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 60.0),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold, fontSize: 32.0),
                  ),
                  const SizedBox(height: 40.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter Confirm Password",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.brown),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Staff';
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'Staff',
                        style: new TextStyle(fontSize: 17.0),
                      ),
                      Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Manager';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Manager',
                        style: new TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Center(
                    child: ButtonTheme(
                      minWidth: 170,
                      height: 60,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.lightGreen[400])),
                        color: Colors.lightGreen[300],
                        textColor: Colors.black,
                        child: Text("회원 가입",
                            style: TextStyle(fontSize: 14)),
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            print("이메일과 패스워드 중 빈칸이 존재합니다.");
                            return;
                          }
                          if (_confirmPasswordController.text.isEmpty ||
                              _passwordController.text !=
                                  _confirmPasswordController.text) {
                            print("패스워드가 일치하지 않습니다");
                            return;
                          }
                          try {
                            final user = await signupWithEmail(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              role: radioButtonItem,
                            );
                            if (user != null) {
                              print("signup successful");
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
