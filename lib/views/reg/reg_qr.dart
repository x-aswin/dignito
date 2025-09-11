import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/registration_controller.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../components/input_field.dart';
import 'package:dignito/custom_colors.dart';
import '../../constants.dart';

class Reg_scanqr extends StatelessWidget {
  const Reg_scanqr({super.key});

  @override
  Widget build(BuildContext context) {
    final Regcontroller qrctrl = Get.put(Regcontroller());
    final AuthController authctrl = Get.put(AuthController());

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.DigBlack,
        body: Container(
          
          // decoration: BoxDecoration(
          //   gradient: RadialGradient(
          //     colors: [
          //       const Color(0xFF008080).withOpacity(0.8), // Darker shade with opacity
          //       const Color(0xFF271C22), // Dark background color
          //     ],
          //     center: Alignment.topCenter,
          //     radius: 0.8, // Adjusted for a more subtle effect
          //     stops: const [0.0, 1.0],
          //   ),
          // ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView( // Wrap with SingleChildScrollView
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Aligns to the top
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0), // Adjust padding as needed
                            child: Image.asset(
                              'assets/logo.png', // Update this path to your logo
                              height: 150, // Increased height for a bigger logo
                              fit: BoxFit.contain, // Maintain aspect ratio
                            ),
                          ),
                          // QR Scanner
                          Container(
                            height: 300.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomColors.regText, width: 3.0),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.transparent,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: QRView(
                              key: qrctrl.qrKey,
                              onQRViewCreated: (QRViewController controller) {
                                qrctrl.qrViewController = controller;
                                controller.scannedDataStream.listen(
                                  qrctrl.onQRCodeScanned,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight *
                                Constants.sizedBoxHeight,
                          ),
                          // Participant ID Input
                          InputField(
                            labelText: 'Participant ID',
                            icon: Icons.person,
                            initialValue: '',
                            onPressedCallback: qrctrl.clearErrorMsg,
                            readOnly: false,
                            controller: qrctrl.candid,
                          ),
                          SizedBox(
                            height: constraints.maxHeight *
                                Constants.sizedBoxHeight,
                          ),
                          // Continue Button
                          button(
                            'Continue',
                            qrctrl.getCandidateDetails,
                            CustomColors.regText,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
