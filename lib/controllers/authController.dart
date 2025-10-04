import 'package:dignito/views/event/homepage.dart';
import 'package:get/get.dart';
import '../views/login.dart';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../views/reg/reg_qr.dart';



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

  void logout() async {
      await LocalStorage.removeValue('Candid');
      await LocalStorage.removeValue('staff_id');
      await LocalStorage.removeValue('category');
      await LocalStorage.removeValue('eventid');
      Get.offAll(() => LoginView());
    }
  }
