import 'package:dignito/controllers/EventController.dart';
import 'package:dignito/controllers/registration_controller.dart';
import 'package:dignito/main.dart';
import 'package:dignito/views/event/homepage.dart';
import 'package:get/get.dart';
import '../views/login.dart';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../views/reg/reg_qr.dart';
//import 'package:restart_app/restart_app.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator



class AuthController extends GetxController {
  void verifyLogout() {
  Get.dialog(
    Theme(
      data: ThemeData.dark(), // Use dark theme
      child: AlertDialog(
        backgroundColor: const Color.fromARGB(255, 65, 30, 30), // background
        title: const Text(
          'Exit',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to exit?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              logout();
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false, // Optional: prevent dismiss by tapping outside
  );
}


  void cancelReg() async {
    await LocalStorage.removeValue('Candid');
    Get.off(() => const RegScanQR());
  }
  
  void cancelchest() async {
    await LocalStorage.removeValue('Candid');
    Get.off(() => const Homepage());
  }

/* void logout() async {
 await LocalStorage.removeValue('Candid');
  await LocalStorage.removeValue('staff_id');
  await LocalStorage.removeValue('category');
  await LocalStorage.removeValue('eventid');

  //Clear all GetX controllers and dependencies
  Get.deleteAll(force: true);

  // clear all navigation history
  Get.offAll(() => LoginView());


 Restart.restartApp(); 
 }
*/
void logout() async {
  // Show loading dialog
  Get.dialog(
    Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );



  // Clear storage and controllers
  await LocalStorage.removeValue('Candid');
  await LocalStorage.removeValue('staff_id');
  await LocalStorage.removeValue('category');
  await LocalStorage.removeValue('eventid');

  // Delete all GetX controllers
  Get.deleteAll(force: true);

  // Restart the app
  //Restart.restartApp();
  SystemNavigator.pop(); // Exits the app
}


}


