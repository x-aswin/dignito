import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/registration_controller.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../components/input_field.dart';
import 'package:dignito/custom_colors.dart';
import '../../constants.dart';

class Reg_scanqr extends StatefulWidget {
  const Reg_scanqr({super.key});

  @override
  State<Reg_scanqr> createState() => _Reg_scanqrState();
}

class _Reg_scanqrState extends State<Reg_scanqr> {
  final Regcontroller qrctrl = Get.put(Regcontroller());
  final AuthController authctrl = Get.put(AuthController());
  final FocusNode _participantFocus = FocusNode();

  @override
  void dispose() {
    _participantFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false, // background fixed
        body: Stack(
          children: [
            // Fixed background
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash_back.png'),
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                  fit: BoxFit.cover,
                ),
                gradient: RadialGradient(
                  colors: [CustomColors.regText, Color(0xFF271C22)],
                  center: Alignment.topCenter,
                  radius: 0.8,
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            // Foreground content
            Positioned.fill(
              child: SafeArea(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(bottom: keyboardInset),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      keyboardInset > 0 ? keyboardInset + 24 : 48,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/dignito_logo.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomColors.regText, width: 3),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: QRView(
                            key: qrctrl.qrKey,
                            onQRViewCreated: (QRViewController controller) {
                              qrctrl.qrViewController = controller;
                              controller.scannedDataStream.listen(qrctrl.onQRCodeScanned);
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * Constants.sizedBoxHeight),
                        // Participant ID input with focus node
                        InputField(
                          labelText: 'Participant ID',
                          icon: Icons.person,
                          initialValue: '',
                          onPressedCallback: qrctrl.clearErrorMsg,
                          controller: qrctrl.candid,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * Constants.sizedBoxHeight),
                        button(
                          'Continue',
                          qrctrl.getCandidateDetails,
                          CustomColors.regText.withOpacity(0.8),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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

