import 'package:dignito/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controllers/registration_controller.dart';
import '../../components/button.dart';
import '../../controllers/authController.dart';
import '../../components/input_field.dart';
import 'package:dignito/custom_colors.dart';
import '../../constants.dart';

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

  Future<Map<String, String>> _getFestAssets() async {
    final festid = await LocalStorage.getValue('festid') ?? '1';

    // Map logo and background assets according to festid
    String background = 'assets/splash_back.png';
    String logo = 'assets/dignito_logo.png'; // default

    if (festid == '1') {
      background = 'assets/daksh_background.png';
      logo = 'assets/daksshtext.png';
    } else{
      background = 'assets/splash_back3.png';
      logo = 'assets/dignito_logo3.png';
    }

    return {'background': background, 'logo': logo};
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
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<Map<String, String>>(
          future: _getFestAssets(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final assets = snapshot.data!;

            return Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(assets['background']!),
                      fit: BoxFit.cover,
                      colorFilter:
                          const ColorFilter.mode(Colors.black54, BlendMode.darken),
                    ),
                    gradient: const RadialGradient(
                      colors: [CustomColors.regText, Color(0xFF271C22)],
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
                            assets['logo']!, // dynamic logo
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: CustomColors.regText, width: 3),
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
                                  Constants.sizedBoxHeight),
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
                            CustomColors.regText.withOpacity(0.8),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

