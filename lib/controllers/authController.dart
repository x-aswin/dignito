import 'package:dignito/views/event/homepage.dart';
import 'package:get/get.dart';
import '../views/login.dart';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../views/reg/reg_qr.dart';
import 'package:restart_app/restart_app.dart';



class AuthController extends GetxController {
  void verifyLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              logout();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
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

  // Small delay to ensure loading is visible
  await Future.delayed(const Duration(milliseconds: 300));

  // Clear storage and controllers
  await LocalStorage.removeValue('Candid');
  await LocalStorage.removeValue('staff_id');
  await LocalStorage.removeValue('category');
  await LocalStorage.removeValue('eventid');

  // Delete all GetX controllers
  Get.deleteAll(force: true);

  // Restart the app
  Restart.restartApp();
}


}


