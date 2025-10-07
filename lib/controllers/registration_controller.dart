/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reg/registration.dart';
import '../services/http_service.dart';
import '../services/local_storage_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../errors.dart';
import '../models/CandDetails.dart';
import '../views/reg/reg_qr.dart';


class Regcontroller extends GetxController {
  final candid = TextEditingController();

  var isLoading = false.obs;
  
  var errorMsg = ''.obs;
  var candId = '';
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRCodeScanned(Barcode scanData) async {
    final String scannedCode = scanData.code ?? '';
    candid.text = scannedCode;
  }

Future<void> getCandidateDetails() async {
    if (candid.text.trim().isEmpty) {
      Get.snackbar("Error", "Empty field", colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true; // start loading

      await LocalStorage.setValue('CandId', candid.text);
      CandidateDetails? candidateDetails = await HttpServices.isCandIdValid();

      if (candidateDetails != null && candidateDetails.cname.isNotEmpty) {
        if (candidateDetails.cname == "Err") {
          Get.snackbar("Unsuccessful", 'Invalid Id', colorText: Colors.white);
        } else {
          Get.to(() => Registration(candidateDetails: candidateDetails));
        }
      } else {
        errorMsg.value = ErrorMessages.InvalidCandidateIdError;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.white);
    } finally {
      isLoading.value = false; // stop loading
    }
  }



var isIssuing = false.obs;

void issuseIdCard() async {
  isIssuing.value = true; // start loading
  bool response = await HttpServices.issueIdCard();
  isIssuing.value = false; // stop loading

  if (response == true) {
    Get.snackbar('Successful', 'ID issued.', colorText: Colors.white);
    await LocalStorage.removeValue('CandId');
    Get.off(() => const RegScanQR());
  } else {
    Get.snackbar('Error', 'Try again', colorText: Colors.white);
    errorMsg.value = ErrorMessages.InvalidCandidateIdError;
  }
}


  void clearErrorMsg() {
    errorMsg.value = '';
  }

  void goBack() {
    Get.back();
  }

}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reg/registration.dart';
import '../services/http_service.dart';
import '../services/local_storage_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../errors.dart';
import '../models/CandDetails.dart';
import '../views/reg/reg_qr.dart';

class Regcontroller extends GetxController {
  final candid = TextEditingController();

  var isLoading = false.obs;
  var errorMsg = ''.obs;
  var candId = '';

  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // Prevent multiple triggers on same QR scan
  var hasScanned = false.obs;

  /// Called when a QR code is scanned
  void onQRCodeScanned(Barcode scanData) async {
    final String scannedCode = scanData.code ?? '';
    if (scannedCode.isEmpty) return;

    // Avoid repeated calls
    if (hasScanned.value) return;
    hasScanned.value = true;

    candid.text = scannedCode;

     Get.snackbar(
  "Participant ID",
  "${candid.text}",
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: const Color.fromARGB(255, 49, 31, 29),
  colorText: Colors.white,
  margin: const EdgeInsets.all(12),
  borderRadius: 8,
  duration: const Duration(seconds: 2),
  icon: const Icon(Icons.account_box, color: Colors.white),
);

    await getCandidateDetails(); // Automatically trigger function
  }

  /// Fetch candidate details using the scanned ID
  Future<void> getCandidateDetails() async {
    if (candid.text.trim().isEmpty) {
      Get.snackbar("Error", "Empty field", colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true; // start loading

      await LocalStorage.setValue('CandId', candid.text);
      CandidateDetails? candidateDetails = await HttpServices.isCandIdValid();

      if (candidateDetails != null && candidateDetails.cname.isNotEmpty) {
        if (candidateDetails.cname == "Err") {
          Get.snackbar("Unsuccessful", 'Invalid Id', colorText: Colors.white);
        } else {
          Get.to(() => Registration(candidateDetails: candidateDetails));
        }
      } else {
        errorMsg.value = ErrorMessages.InvalidCandidateIdError;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong", colorText: Colors.white);
    } finally {
      isLoading.value = false; // stop loading
      hasScanned.value = false; // reset for next scan
    }
  }

  var isIssuing = false.obs;

  /// Issue ID card (used after registration)
  void issuseIdCard() async {
    isIssuing.value = true; // start loading
    bool response = await HttpServices.issueIdCard();
    isIssuing.value = false; // stop loading

    if (response == true) {
      Get.snackbar('Successful', 'ID issued.', colorText: Colors.white);
      await LocalStorage.removeValue('CandId');
      Get.off(() => const RegScanQR());
    } else {
      Get.snackbar('Error', 'Try again', colorText: Colors.white);
      errorMsg.value = ErrorMessages.InvalidCandidateIdError;
    }
  }

  /// Clear error message (used by commented input field)
  
  void clearErrorMsg() {
    errorMsg.value = '';
  }
  

  /// Go back (used by commented navigation button)
  
  void goBack() {
    Get.back();
  }
  
}

