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

class RegScanQR extends StatefulWidget {
  const RegScanQR({super.key});

  @override
  State<RegScanQR> createState() => _RegScanQRState();
}

class _RegScanQRState extends State<RegScanQR> {
  final Regcontroller qrctrl = Get.put(Regcontroller());
  final AuthController authctrl = Get.put(AuthController());

  @override
  void dispose() {
    qrctrl.qrViewController?.dispose();
    super.dispose();
  }

  // Get assets synchronously
  final String background = FestAssets.getBackground();
  final String logo = FestAssets.getLogo();

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background
            Container(
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
            ),

            // Foreground content
            SafeArea(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: keyboardInset + 16),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        logo,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.regTextColor, width: 3),
                          borderRadius: BorderRadius.circular(8),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            Constants.sizedBoxHeight,
                      ),
                      InputField(
                        labelText: 'Participant ID',
                        icon: Icons.person,
                        initialValue: '',
                        onPressedCallback: qrctrl.clearErrorMsg,
                        controller: qrctrl.candid,
                      ),
                      const SizedBox(height: 20),
                      button(
                        'Continue',
                        qrctrl.getCandidateDetails,
                        CustomColors.buttonColor.withOpacity(0.8),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
