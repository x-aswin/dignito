import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/EventController.dart';
import '../../components/eventTextField.dart';
import '../../components/chestnumber.dart';
import '../../constants.dart';
import '../../controllers/authController.dart';
import '../../models/ParticipantDetails.dart';
import '../../custom_colors.dart';

class EventDetails extends StatelessWidget {
  final Participantdetails participantdetails;

  const EventDetails({super.key, required this.participantdetails});

  @override
  Widget build(BuildContext context) {
    final Eventcontroller eventctrl = Get.put(Eventcontroller());
    final AuthController authctrl = Get.put(AuthController());

    final String initialChestCode = participantdetails.chestcode;
    final String initialChestNumber = participantdetails.chestnumber.toString();
    eventctrl.allocatedNumberController.text = initialChestNumber;

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
                      // Add Logo/Image at the top (if required)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(
                          'assets/logo.png', // Replace with actual path
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      // Event Name
                      

                      // Institution Name
                      EventText(
                        labelText: 'Institution Name',
                        icon: Icons.account_balance,
                        initialValue: participantdetails.iname,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),

                      // Participant Name
                      EventText(
                        labelText: 'Participant Name',
                        icon: Icons.person,
                        initialValue: participantdetails.cname,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      EventText(
                        labelText: 'Event Name',
                        icon: Icons.event,
                        initialValue: participantdetails.events,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      EventText(
                        labelText: 'Payment Status',
                        icon: participantdetails.paystatus == 'Paid' ? Icons.check_circle : Icons.hourglass_empty,
                        initialValue: participantdetails.paystatus,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      // Chest Number
                      if(participantdetails.paystatus == 'Paid') ...[
                        
                      ChestField(
                        icon: Icons.confirmation_number,
                        fixedString: participantdetails.chestcode,
                        initialNumber: participantdetails.chestnumber,
                        numberController: eventctrl.allocatedNumberController,
                        isEditable: participantdetails.cheststatus,
                        
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      ],

                      // Cancel Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            authctrl.cancelchest();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.backgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
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

                      // Verify Button
                      if (participantdetails.paystatus == 'Paid') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            eventctrl.allocateNumber(participantdetails);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.regText,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
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
