import 'package:dignito/views/event/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/errors.dart';
import '../services/http_service.dart';
import '../views/reg/reg_qr.dart';
import '../services/local_storage_service.dart';
import '../services/shared_pref_service.dart';
import '../views/login.dart';
//import '../views/hi.dart';
//import 'package:dignito/services/local_storage_service.dart';

class LoginController extends GetxController {
  String username = '';
  String password = '';
  String key = '';
  String errorMsg = '';
  final String oldPasswd = 'oldpass';
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final keyCtrl = TextEditingController();
    // Role options for the dropdown


  void validateInputs() async {
    if (usernameCtrl.text.trim() == '' || passwordCtrl.text.trim() == '') {
      errorMsg = ErrorMessages.emptyInputFieldsError;
    } else {
      // if(selectedRole == 'Student'){
      //   usertype = 1;
      // } else {
      //   usertype = 0;
      // }
      username = usernameCtrl.text.trim();
      password = passwordCtrl.text.trim();
      bool loginStatus = await HttpServices.login(username, password);
      if(loginStatus == true)
      {
        clearErrorMsg();
        String? category = await LocalStorage.getValue('category');
        if( category == '2'){
          print("registration");
          Get.to(() => const RegScanQR());
        } else if ( category == "2"){
          Get.to(() => const RegScanQR());
        } else if ( category == "4"){
          print("event"); 
          Get.to(() => const Homepage());
        } else {
          errorMsg = "Contact Admin";
        }    
      } else {
      errorMsg = 'Invalid Credentials!';
      } 
    }
    update();
  }

  void validateInputskey() async {
    if (usernameCtrl.text.trim() == '' || passwordCtrl.text.trim() == '' || keyCtrl.text.trim() == '') {
      errorMsg = ErrorMessages.emptyInputFieldsErrorkey;
    } else {
      
      username = usernameCtrl.text.trim();
      password = passwordCtrl.text.trim();
      key=keyCtrl.text.trim();
      bool loginStatus = await HttpServices.loginkey(username, password, key);
      if(loginStatus == true)
      {
        clearErrorMsg();
        String appKey = await SharedPrefHelper.getAppKey();
        if(appKey != ''){
          //clearFields();
          Get.to(() => LoginView());
          update();
        } else {
          errorMsg = "Contact Admin";
        }
      } else {
        errorMsg = 'Invalid Credentials or Key!';
      }

    }
    update();
  }


  void clearFields() {
    usernameCtrl.clear();
    passwordCtrl.clear();
  }


  void clearErrorMsg() {
    errorMsg = '';
    update();
  }



  @override
  void onClose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}




