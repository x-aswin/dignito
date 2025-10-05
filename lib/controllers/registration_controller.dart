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

}
