import '../../custom_colors.dart';
import 'package:flutter/material.dart';
import '../../models/CandDetails.dart';
import '../../components/events_field.dart';
import '../../components/textfield.dart';
import '../../controllers/registration_controller.dart';
import 'package:get/get.dart';
import '../../controllers/authController.dart';
import '../../services/local_storage_service.dart';

class Registration extends StatelessWidget {
  final CandidateDetails candidateDetails;

  const Registration({super.key, required this.candidateDetails});

  Future<Map<String, String>> _getFestAssets() async {
    final festid = await LocalStorage.getValue('festid') ?? '1';

    // Map logo and background assets according to festid
    String background = 'assets/splash_back.png';
    String logo = 'assets/dignito_logo.png'; // default

    if (festid == '5') {
      background = 'assets/daksh_background.png';
      logo = 'assets/daksshtext.png';
    } 

    return {'background': background, 'logo': logo};
  }

  @override
  Widget build(BuildContext context) {
    final Regcontroller regctrl = Get.put(Regcontroller());
    final AuthController authctrl = Get.put(AuthController());

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<Map<String, String>>(
            future: _getFestAssets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text("Error loading assets"));
              }

              final background = snapshot.data!['background']!;
              final logo = snapshot.data!['logo']!;

              return LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(background),
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                          Colors.black54,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Logo at the top
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Image.asset(
                                logo,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Institution Name
                            Textfield(
                              labelText: 'Institution Name',
                              icon: Icons.account_balance,
                              initialValue: candidateDetails.iname,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.05),

                            // Participant Name
                            Textfield(
                              labelText: 'Participant Name',
                              icon: Icons.person,
                              initialValue: candidateDetails.cname,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.05),

                            // ID Card Status
                            Textfield(
                              labelText: 'ID Card Status',
                              initialValue: candidateDetails.status == 0
                                  ? 'Issued'
                                  : 'Not Issued',
                            ),
                            SizedBox(height: constraints.maxHeight * 0.1),

                            // Cancel Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  authctrl.cancelReg();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomColors.backgroundColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),

                            // Issue Button (only visible if candidateDetails.status == 1)
                            if (candidateDetails.status == 1) ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    regctrl.issuseIdCard();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CustomColors.regText,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Issue',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
