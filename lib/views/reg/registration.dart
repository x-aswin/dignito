import '../../custom_colors.dart';
import 'package:flutter/material.dart';
import '../../models/CandDetails.dart';
import '../../components/events_field.dart';
import '../../components/textfield.dart';
import '../../controllers/registration_controller.dart';
import 'package:get/get.dart';
import '../../controllers/authController.dart';

class Registration extends StatelessWidget {
   final CandidateDetails candidateDetails;

  const Registration({super.key, required this.candidateDetails});
  
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
        backgroundColor: CustomColors.DigBlack,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Add Image at the top
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(
                          'assets/logo.png', // Replace with your image path
                          height: 200, // Set the height of the image
                          fit: BoxFit.contain, // Adjust fit as necessary
                        ),
                      ),
                      // Institution Name
                      Textfield(
                        labelText: 'Institution Name',
                        icon: Icons.account_balance,
                        initialValue: candidateDetails.iname, // Fill Institution Name
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),

                      // Participant Name
                      Textfield(
                        labelText: 'Participant Name',
                        icon: Icons.person,
                        initialValue: candidateDetails.cname, // Fill Candidate Name
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),

                      // ID Card Status
                      Textfield(
                        labelText: 'ID Card Status',
                        initialValue: candidateDetails.status == 0 ? 'Issued' : 'Not Issued', // Handle Status
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      SizedBox(height: constraints.maxHeight * 0.1),

                      // Cancel Button
                      SizedBox(
                        width: double.infinity, // Make button full width
                        child: ElevatedButton(
                          onPressed: () {
                            authctrl.cancelReg();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.backgroundColor,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                      SizedBox(height: constraints.maxHeight * 0.02), // Space between buttons

                      // Issue Button (only visible if candidateDetails.status is 0)
                      if (candidateDetails.status == 1) ...[
                        SizedBox(
                          width: double.infinity, // Make button full width
                          child: ElevatedButton(
                            onPressed: () {
                              regctrl.issuseIdCard();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.regText,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
