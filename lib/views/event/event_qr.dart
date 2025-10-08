import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controllers/EventController.dart';
import '../../components/input_field.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../custom_colors.dart';
import '../../services/assets_manager.dart';

class EventQr extends StatelessWidget {
  const EventQr({super.key});

  @override
  Widget build(BuildContext context) {
    final Eventcontroller eventctrl = Get.put(Eventcontroller());
    final AuthController authctrl = Get.put(AuthController());

    final String background = FestAssets.getBackground();
    final String logo = FestAssets.getLogo();

    // ✅ MobileScanner controller instance
    final MobileScannerController mobileScannerController =
        MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
      torchEnabled: false,
    );

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background),
            fit: BoxFit.cover,
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (eventctrl.isLoading.value) {
              // ✅ Loading overlay
              return Container(
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(logo, height: 300),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        'Hold tight, we are fetching data...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // ✅ QR scanner and layout
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Image.asset(logo, height: 150),
                        ),
                        // ✅ MobileScanner replaces QRView
                        Container(
                          height: 300.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomColors.regTextColor, width: 3.0),
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: MobileScanner(
                            controller: mobileScannerController,
                            onDetect: (BarcodeCapture capture) {
                              final barcode = capture.barcodes.first;
                              final String? scannedCode = barcode.rawValue;
                              if (scannedCode != null &&
                                  scannedCode.isNotEmpty) {
                                eventctrl.onQRCodeDetected(capture);

                                // Automatically go to event details
                                if (eventctrl.participantid.text.isNotEmpty) {
                                  eventctrl.eventDetailsPage();
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 56),

                        // ✅ Optional participant input & continue button (commented)
                        /*
                        InputField(
                          labelText: 'Participant ID',
                          icon: Icons.person,
                          initialValue: '',
                          onPressedCallback: eventctrl.clearErrorMsg,
                          readOnly: true,
                          controller: eventctrl.participantid,
                        ),
                        const SizedBox(height: 20),
                        button(
                          'Continue',
                          eventctrl.eventDetailsPage,
                          CustomColors.buttonColor,
                        ),
                        */
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
