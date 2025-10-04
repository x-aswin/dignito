import 'package:dignito/views/event/event_qr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/http_service.dart';
import '../services/local_storage_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../errors.dart';
import '../models/ParticipantDetails.dart';
import '../views/event/event_details.dart';
import '../views/event/homepage.dart';


class Eventcontroller extends GetxController {
  final participantid = TextEditingController();
  final TextEditingController allocatedNumberController = TextEditingController();
  final TextEditingController firstPrizeController = TextEditingController();
  final TextEditingController secondPrizeController = TextEditingController();
  final TextEditingController secondPrizeinst = TextEditingController();
  final TextEditingController firstPrizeinst = TextEditingController();
  final TextEditingController secondPrizememb = TextEditingController();
  final TextEditingController firstPrizememb = TextEditingController();

  var errorMsg = ''.obs;
  var firstPrizeDetails = ''.obs;  
  var secondPrizeDetails = ''.obs; 
  var errorMessage = ''.obs;

   var isLoading = false.obs; 


  QRViewController? qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRCodeScanned(Barcode scanData) async {
    final String scannedCode = scanData.code ?? '';
    participantid.text = scannedCode;
  }

  void eventDetailsPage() async {
  if (participantid.text.trim().isEmpty) {
    Get.snackbar('Error', 'Participant ID cannot be empty', colorText: Colors.white);
    return;
  }

  isLoading.value = true; // show loading

  try {
    String partid = participantid.text;
    await LocalStorage.setValue('CandId', partid);
    Participantdetails? participantDetails = await HttpServices.EventId();

    if (participantDetails != null && participantDetails.cname.isNotEmpty) {
      if (participantDetails.cname == "Err") {
        Get.snackbar('Unsuccessful', 'Invalid ID', colorText: Colors.white);
      } else {
        Get.off(() => EventDetails(participantdetails: participantDetails));
      }
    } else {
      Get.snackbar('Error', 'Please try again', colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
  } finally {
    isLoading.value = false; // hide loading
  }
}


  void allocateNumber(Participantdetails partdet) async{
    partdet.chestnumber = allocatedNumberController.text.trim();
    bool response = await HttpServices.issueChestNumber(partdet);
    if(!response){
      Get.snackbar('Unsuccessful', 'An error occured', colorText: Colors.white);
    }// else {
    //   Get.snackbar("Unsuccessful", 'An error occured');
    // }
    Get.off(() => const Homepage());
  }


  void fetchDetails(int position) async {
    if(position == 1){
      final chestno = firstPrizeController.text.trim();
      var response = await HttpServices.getplacementDetails(chestno);
      if (response == false){

      } else {
        firstPrizeinst.text = response.instname;
        firstPrizememb.text = response.members;
      }
    } else {
      final chestno = secondPrizeController.text.trim();
      var response = await HttpServices.getplacementDetails(chestno);
      if (response == false){

      } else {
        secondPrizeinst.text = response.instname;
        secondPrizememb.text = response.members;
      }
    }
  }

  void postPlacements() async {
   final firstposition = firstPrizeController.text.trim();
   final secondposition = secondPrizeController.text.trim();
   final Response = await HttpServices.postplacement(firstposition,secondposition);
  }

  void clearErrorMsg() {
    errorMsg.value = '';
  }

  void goBack() {
    Get.back();
  }

}
