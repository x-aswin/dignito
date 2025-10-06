 
  import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/main.dart';
  import 'package:dignito/services/local_storage_service.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:dignito/services/shared_pref_service.dart';
  import 'package:dignito/views/login.dart'; 
  import 'package:dignito/views/initial_login.dart'; 
  import 'package:dignito/services/assets_manager.dart';

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
      
      //loading assets
      await FestAssets.loadFestId();

      if (appKey =='') {
        print("No appKey found, navigating to LoginWithKey");
        Future.microtask(() {
          Get.offAll(() => LoginWithKey()); 
        });
      } else {
        print("AppKey found, navigating to LoginView");
        Map<String, String> loginData = await SharedPrefHelper.getLoginInfo();
        print("Login Data: $loginData");


      if (loginData['username'] !='') {
        Get.snackbar(
  "Info",
  "Your login info has been filled. Please proceed to login.",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: const Color.fromARGB(255, 50, 90, 70), // a nice greenish tone
  colorText: Colors.white,
  margin: const EdgeInsets.all(12),
  borderRadius: 8,
  duration: const Duration(seconds: 4),
  icon: const Icon(Icons.check_circle_outline, color: Colors.white),
);
}


        LoginController loginController = Get.put(LoginController());
        ///LoginController loginController = Get.find();
        loginController.usernameCtrl.text = loginData['username']!;
        loginController.passwordCtrl.text = loginData['password']!;
        

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
