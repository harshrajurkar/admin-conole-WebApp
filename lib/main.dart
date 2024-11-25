import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vrv_security/apptheme.dart';
import 'package:vrv_security/pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'package:vrv_security/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: appTheme,
      home: LoginPage(),
    );
  }
}
