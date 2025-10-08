import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/reg/registration.dart';
import '../services/http_service.dart';
import '../services/local_storage_service.dart';
import '../errors.dart';
import '../models/CandDetails.dart';
import '../views/reg/reg_qr.dart';

class Regcontroller extends GetxController {
  final candid = TextEditingController();

  var isLoading = false.obs;
  var errorMsg = ''.obs;
  var candId = '';
  var hasScanned = false.obs;
  var isIssuing = false.obs;

  /// ✅ Called when QR code is detected
  Future<void> onQRCodeScanned(String scannedCode) async {
    if (scannedCode.isEmpty) return;

    // Prevent double scan trigger
    if (hasScanned.value) return;
    hasScanned.value = true;

    candid.text = scannedCode;

    // Show participant ID
    Get.snackbar(
      "Participant ID",
      candid.text,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 49, 31, 29),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.qr_code, color: Colors.white),
    );

    await getCandidateDetails();
  }

  /// ✅ Fetch candidate details from APIw
  Future<void> getCandidateDetails() async {
    if (candid.text.trim().isEmpty) {
      Get.snackbar("Error", "Empty field", colorText: Colors.white);
      hasScanned.value = false;
      return;
    }

    try {
      isLoading.value = true;

      await LocalStorage.setValue('CandId', candid.text);
      CandidateDetails? candidateDetails = await HttpServices.isCandIdValid();

      if (candidateDetails != null && candidateDetails.cname.isNotEmpty) {
        if (candidateDetails.cname == "Err") {
          Get.snackbar("Unsuccessful", "Invalid ID", colorText: Colors.white);
        } else {
          // Safely navigate (avoid multiple pushes)
          if (Get.isOverlaysOpen) Get.back();
          if (Get.currentRoute != '/Registration') {
            await Get.to(() => Registration(candidateDetails: candidateDetails));
          }
        }
      } else {
        errorMsg.value = ErrorMessages.InvalidCandidateIdError;
        Get.snackbar("Error", "Invalid Candidate ID", colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("❌ getCandidateDetails error: $e");
      Get.snackbar("Error", "Something went wrong", colorText: Colors.white);
    } finally {
      isLoading.value = false;
      // Allow next scan after short delay (prevents rapid re-scan errors)
      await Future.delayed(const Duration(seconds: 1));
      hasScanned.value = false;
    }
  }

  /// ✅ Issue ID Card after registration
  Future<void> issueIdCard() async {
    try {
      isIssuing.value = true;
      bool response = await HttpServices.issueIdCard();
      if (response) {
        Get.snackbar('Success', 'ID issued successfully', colorText: Colors.white);
        await LocalStorage.removeValue('CandId');

        // Delay ensures previous camera controller releases properly
        await Future.delayed(const Duration(milliseconds: 300));
        //Get.offAll(() => const RegScanQR());
      } else {
        Get.snackbar('Error', 'Try again', colorText: Colors.white);
        errorMsg.value = ErrorMessages.InvalidCandidateIdError;
      }
    } catch (e) {
      debugPrint("❌ issueIdCard error: $e");
      Get.snackbar('Error', 'Something went wrong', colorText: Colors.white);
    } finally {
      isIssuing.value = false;
    }
  }

  /// ✅ Clear any old errors
  void clearErrorMsg() {
    errorMsg.value = '';
  }

  /// ✅ Safe navigation back
  void goBack() {
    if (Get.isOverlaysOpen) Get.back();
    else if (Get.previousRoute.isNotEmpty) Get.back();
  }

  /// ✅ Clean up resources
  @override
  void onClose() {
    candid.dispose();
    super.onClose();
  }
}
