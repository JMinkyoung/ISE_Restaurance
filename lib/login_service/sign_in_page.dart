import 'package:restaurance/login_service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurance/login_service/sign_up_page.dart';


class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Restaurance",
                  style: TextStyle(fontFamily: 'BethEllen', color: Colors.brown[800], fontSize: 40.0),
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold, fontSize: 32.0),
                ),
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                child: Column(
                  children: [
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.brown),
                          ),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    RaisedButton(
                      onPressed: () {
                        context.read<AuthenticationService>().signIn(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                      },
                      textColor: Colors.brown[800],
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFFD180),
                              Color(0xFFFFE0B2),
                              Color(0xFFFFD180),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: const Text(
                              'Sign in',
                              style: TextStyle(fontSize: 18)
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    RaisedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignupPage(),
                            ));
                      },
                      textColor: Colors.brown[800],
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFFFD180),
                              Color(0xFFFFE0B2),
                              Color(0xFFFFD180),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: const Text(
                              'Create Account',
                              style: TextStyle(fontSize: 18)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
