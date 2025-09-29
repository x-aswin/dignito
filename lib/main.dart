import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/login.dart';
import 'views/initial_login.dart';
import 'package:get/get.dart';
import 'start_up.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ufarms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StartUpPage(),
    );
  }
}
