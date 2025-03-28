import 'package:firebase_core/firebase_core.dart';
import 'package:flashsmith/auth/auth.dart';
import 'package:flashsmith/firebase_options.dart';
import 'package:flashsmith/themes/darkmode.dart';
import 'package:flashsmith/themes/lightmode.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authpage(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
