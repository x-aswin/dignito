import 'package:dignito/views/event/event_qr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/http_service.dart';
import '../services/local_storage_service.dart';
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

  var isLoading = false.obs;
  var issubmiting = false.obs;
  var errorMsg = ''.obs;
  var firstPrizeDetails = ''.obs;  
  var secondPrizeDetails = ''.obs; 
  var errorMessage = ''.obs;

  // ✅ For MobileScanner
  final MobileScannerController mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  /// ✅ Called when a QR is detected by MobileScanner
  void onQRCodeDetected(BarcodeCapture capture) async {
    if (capture.barcodes.isEmpty) return;

    final Barcode barcode = capture.barcodes.first;
    final String scannedCode = barcode.rawValue ?? '';

    if (scannedCode.isNotEmpty) {
      participantid.text = scannedCode;
      print("Scanned Code: $scannedCode");
/*
      Get.snackbar(
        "Participant ID",
        scannedCode,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 49, 31, 29),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(microseconds: 500),
        icon: const Icon(Icons.qr_code_2, color: Colors.white),
      );
      */

      // ✅ Automatically move to event details page
      await Future.delayed(const Duration(seconds: 1));
      eventDetailsPage();
    }
  }

  /// Fetch Event Details
  void eventDetailsPage() async {
    if (participantid.text.trim().isEmpty) {
      Get.snackbar('Error', 'Participant ID cannot be empty', colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      String partid = participantid.text;
      await LocalStorage.setValue('CandId', partid);
      Participantdetails? participantDetails = await HttpServices.EventId();

      if (participantDetails != null && participantDetails.cname.isNotEmpty) {
        if (participantDetails.cname == "Err") {
          Get.snackbar('Unsuccessful', 'Invalid ID', colorText: Colors.white);
        } else {
          Get.to(() => EventDetails(participantdetails: participantDetails));
        }
      } else {
        Get.snackbar('Error', 'Please try again', colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void allocateNumber(Participantdetails partdet) async {
    try {
      issubmiting.value = true;
      partdet.chestnumber = allocatedNumberController.text.trim();
      bool response = await HttpServices.issueChestNumber(partdet);

      if (!response) {
       Get.snackbar('Unsuccessful', 'An error occurred', colorText: Colors.white);
       
      } else {
        print(
          'Chest number allocated successfully',
        );
       // Get.snackbar('Successful', 'Chest number allocated successfully', colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
    } finally {
      issubmiting.value = false;
    }
  }

  void fetchDetails(int position) async {
    isLoading.value = true;
    try {
      if (position == 1) {
        final chestno = firstPrizeController.text.trim();
        var response = await HttpServices.getplacementDetails(chestno);
        if (response != false) {
          firstPrizeinst.text = response.instname;
          firstPrizememb.text = response.members;
        } else {
          //Get.snackbar('Error', 'Details not found', colorText: Colors.white);
          print("details not found!");
        }
      } else {
        final chestno = secondPrizeController.text.trim();
        var response = await HttpServices.getplacementDetails(chestno);
        if (response != false) {
          secondPrizeinst.text = response.instname;
          secondPrizememb.text = response.members;
        } else {
          Get.snackbar('Error', 'Details not found', colorText: Colors.white);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void placements() {
    if (secondPrizeinst.text.isEmpty) {
      secondpriceconfirm();
    } else {
      postPlacements();
    }
  }

  void postPlacements() async {
    isLoading.value = true;
    try {
      if (secondPrizeinst.text.isEmpty) {
        final firstposition = firstPrizeController.text.trim();
        await HttpServices.postplacement1(firstposition);
      } else {
        final firstposition = firstPrizeController.text.trim();
        final secondposition = secondPrizeController.text.trim();
        await HttpServices.postplacement(firstposition, secondposition);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearErrorMsg() => errorMsg.value = '';
  void goBack() => Get.back();

  void secondpriceconfirm() {
    Get.dialog(
      Theme(
        data: ThemeData.dark(),
        child: AlertDialog(
          backgroundColor: const Color.fromARGB(255, 65, 30, 30),
          title: const Text('Confirmation', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to add Only First Prize?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No', style: TextStyle(color: Colors.blueAccent)),
            ),
            TextButton(
              onPressed: () {
                postPlacements();
                Get.back();
              },
              child: const Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
