import 'package:care_utility/MainFiles/home_page.dart';
import 'package:care_utility/archive/test_screen.dart';
import 'package:flutter/material.dart';
import 'MainFiles/login_page_new.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:care_utility/ConfidentialVault/Auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CU Manager',
      home: LoginPage(
        title: 'Login',
      ),
      // home: HomePage(),
    );
  }
}
