import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/EventController.dart';
import '../../components/eventTextField.dart';
import '../../components/chestnumber.dart';
import '../../constants.dart';
import '../../controllers/authController.dart';
import '../../models/ParticipantDetails.dart';
import '../../custom_colors.dart';
import '../../services/assets_manager.dart'; 

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

       // Get assets synchronously
    final String background = FestAssets.getBackground();
    final String logo = FestAssets.getLogo();

    return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              fit: BoxFit.cover,
            ),
            gradient: RadialGradient(
              colors: [
                CustomColors.regText,
                Color(0xFF271C22),
              ],
              center: Alignment.topCenter,
              radius: 0.8,
              stops: [0.0, 1.0],
            ),
          ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                    
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(
                          logo, 
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
      ),
    );
  }
}
