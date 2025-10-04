import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
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

return WillPopScope(
  onWillPop: () async {
    authctrl.verifyLogout();
    return false;
  },
  child: Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(  // ❌ remove const
      image: DecorationImage(
        image: AssetImage(background), // dynamic
        fit: BoxFit.cover,
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.darken),
      ),
    ),
    child: SafeArea(
  child: Obx(() {
     if (eventctrl.isLoading.value) {
    return Container(
      color: Colors.black45, // semi-transparent overlay
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              logo, // dynamic logo
              height: 300,
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
  }else {
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
                    border: Border.all(color: CustomColors.regText, width: 3.0),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.transparent,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: QRView(
                    key: eventctrl.qrKey,
                    onQRViewCreated: (QRViewController controller) {
                      eventctrl.qrViewController = controller;
                      controller.scannedDataStream.listen((scanData) {
                        eventctrl.onQRCodeScanned(scanData);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 56),
                // Participant ID input
                InputField(
                  labelText: 'Participant ID',
                  icon: Icons.person,
                  initialValue: '',
                  onPressedCallback: eventctrl.clearErrorMsg,
                  readOnly: false,
                  controller: eventctrl.participantid,
                ),
                const SizedBox(height: 20),
                // Continue Button
                button(
                  'Continue',
                  eventctrl.eventDetailsPage,
                  CustomColors.regText,
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
);

  }
}
