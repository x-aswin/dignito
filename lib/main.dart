 import 'package:dignito/custom_colors.dart';
import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/login.dart';
import 'views/initial_login.dart';
import 'package:get/get.dart';
import 'start_up.dart';
void main() async{
    WidgetsFlutterBinding.ensureInitialized();

    await CustomColors.updateRegTextColor(); // wait for festId
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fest - DiST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: StartUpPage(),
    );
  }
}
