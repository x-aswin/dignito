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
  
  var errorMsg = ''.obs;
  var candId = '';
  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRCodeScanned(Barcode scanData) async {
    final String scannedCode = scanData.code ?? '';
    candid.text = scannedCode;
  }

void getCandidateDetails() async {
  if(candid.text == ''){
    Get.snackbar("Error", "Empty field",
    colorText: Colors.white);
  } else{
     await LocalStorage.setValue('CandId', candid.text);
    CandidateDetails? candidateDetails = await HttpServices.isCandIdValid();
    if (candidateDetails != null && candidateDetails.cname.isNotEmpty) {
      if(candidateDetails.cname == "Err"){
        Get.snackbar("Unsuccessful", 'Invalid Id',
        colorText: Colors.white);
      } else {
        Get.off(() => Registration(candidateDetails: candidateDetails));
      }
  } else {
    errorMsg.value = ErrorMessages.InvalidCandidateIdError;
  }
  }
 
}



  void issuseIdCard() async {
  bool response = await HttpServices.issueIdCard();

  if (response == true) {
    Get.snackbar('Successful','ID issued.', colorText: Colors.white);
    await LocalStorage.removeValue('CandId');
    Get.off(() => const RegScanQR());
  } else {
    Get.snackbar('error', 'try again', colorText: Colors.white);
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
