import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/KyewonPark/AndroidStudioProjects/restaurance/lib/login_service/authentication_service.dart';
import 'file:///C:/Users/KyewonPark/AndroidStudioProjects/restaurance/lib/login_service/authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //파이어베이스의 앱 초기화 기다림
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //다음의 두 위젯을 MaterialApp부터 사용가능하게 함
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(), //로그인 여부에 따라 홈페이지로 갈지 인증페이지로 갈지 결정
      ),
    );
  }
}

