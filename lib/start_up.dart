import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/services/shared_pref_service.dart';
import 'package:dignito/views/login.dart'; 
import 'package:dignito/views/initial_login.dart'; 

class StartUpPage extends StatefulWidget {
  const StartUpPage({super.key});

  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  @override
  void initState() {
    super.initState();
    _checkAppKey();
  }

 
  Future<void> _checkAppKey() async {
    String? appKey = await SharedPrefHelper.getAppKey();

    if (appKey =='') {
      print("No appKey found, navigating to LoginWithKey");
      Future.microtask(() {
        Get.offAll(() => LoginWithKey()); 
      });
    } else {
      print("AppKey found, navigating to LoginView");
      Future.microtask(() {
        Get.offAll(() => LoginView()); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 49, 50, 52),
      body: Center(
        child: CircularProgressIndicator(), // Show a loading spinner while checking
      ),
    );
  }
}
