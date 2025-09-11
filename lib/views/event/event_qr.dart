import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/EventController.dart';
import '../../components/input_field.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../custom_colors.dart';

class EventQr extends StatelessWidget {
  const EventQr({super.key});

  @override
  Widget build(BuildContext context) {
    final Eventcontroller eventctrl = Get.put(Eventcontroller());
    final AuthController authctrl = Get.put(AuthController());

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomColors.DigBlack,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView( // Wrap with SingleChildScrollView
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Logo at the top center
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 150,
                          ),
                        ),
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
                        // Participant ID Input Field
                        InputField(
                          labelText: 'Participant ID',
                          icon: Icons.person,
                          initialValue: '',
                          onPressedCallback: eventctrl.clearErrorMsg,
                          readOnly: false,
                          controller: eventctrl.participantid,
                        ),
                        const SizedBox(height: 20), // Add space before the button
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
            },
          ),
        ),
      ),
    );
  }
}
