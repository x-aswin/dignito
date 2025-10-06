import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/registration_controller.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../components/input_field.dart';
import 'package:dignito/custom_colors.dart';
import '../../constants.dart';
import '../../services/assets_manager.dart';

class RegScanQR extends StatelessWidget {
  const RegScanQR({super.key});

  @override
  Widget build(BuildContext context) {
    final Regcontroller qrctrl = Get.put(Regcontroller());
    final AuthController authctrl = Get.put(AuthController());

    final String background = FestAssets.getBackground();
    final String logo = FestAssets.getLogo();

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
                Colors.black54, BlendMode.darken),
          ),
                gradient:  RadialGradient(
                  colors: [CustomColors.regTextColor, Color(0xFF271C22)],
                  center: Alignment.topCenter,
                  radius: 0.8,
                  stops: [0.0, 1.0],
                ),
              ),
            
        child: SafeArea(
          child: Obx(() {
            if (qrctrl.isLoading.value) {
              // Full-screen loading overlay
              return Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        logo,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      // Spinner
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      // Loading message
                      const Text(
                        'Hold tight, we are fetching data...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // Main QR page content
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Logo
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Image.asset(
                            logo,
                            height: 150,
                          ),
                        ),
                        // QR scanner box
                        Container(
                          height: 300.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomColors.regTextColor, width: 3),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: QRView(
                            key: qrctrl.qrKey,
                            onQRViewCreated: (QRViewController controller) {
                              qrctrl.qrViewController = controller;
                              controller.scannedDataStream
                                  .listen(qrctrl.onQRCodeScanned);
                            },
                          ),
                        ),
                        const SizedBox(height: 56),
                        // Participant ID input
                        InputField(
                          labelText: 'Participant ID',
                          icon: Icons.person,
                          initialValue: '',
                          onPressedCallback: qrctrl.clearErrorMsg,
                          readOnly: false,
                          controller: qrctrl.candid,
                        ),
                        const SizedBox(height: 20),
                        // Continue Button
                        button(
                          'Continue',
                          qrctrl.getCandidateDetails,
                          CustomColors.buttonColor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
      ),
    );
    
  }
}
