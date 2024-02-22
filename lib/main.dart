import 'package:flutter/material.dart';
// import 'MainFiles/login_page.dart';
import 'try_file.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'CU Manager',
      home: LoginPage(title: 'Login',),
    );
  }
}
