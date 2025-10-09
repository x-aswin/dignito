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

class EventDetails extends StatefulWidget {
  final Participantdetails participantdetails;

  const EventDetails({super.key, required this.participantdetails});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final Eventcontroller eventctrl = Get.put(Eventcontroller());
  final AuthController authctrl = Get.put(AuthController());

  late TextEditingController chestNumberController;
  late String background;
  late String logo;

  @override
  void initState() {
    super.initState();

    // Initialize background and logo once
    background = FestAssets.getBackground();
    logo = FestAssets.getLogo();

    // Initialize controller with server value (fresh every time)
    chestNumberController = TextEditingController(
      text: widget.participantdetails.chestnumber.toString(),
    );
  }

  @override
  void dispose() {
    // Dispose controller properly
    chestNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        // Just go back normally
        return true;
      },
      child: Scaffold(
        body: Container(
          height: constraints.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              fit: BoxFit.cover,
            ),
            gradient: RadialGradient(
              colors: [
                CustomColors.regText,
                const Color(0xFF271C22),
              ],
              center: Alignment.topCenter,
              radius: 0.8,
              stops: const [0.0, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
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

                    // Institution Name
                    EventText(
                      labelText: 'Institution Name',
                      icon: Icons.account_balance,
                      initialValue: widget.participantdetails.iname,
                    ),
                    SizedBox(height: constraints.height * 0.03),

                    // Participant Name
                    EventText(
                      labelText: 'Participant Name',
                      icon: Icons.person,
                      initialValue: widget.participantdetails.cname,
                    ),
                    SizedBox(height: constraints.height * 0.03),

                    // Event Name
                    EventText(
                      labelText: 'Event Name',
                      icon: Icons.event,
                      initialValue: widget.participantdetails.events,
                    ),
                    SizedBox(height: constraints.height * 0.03),

                    // Payment Status
                    EventText(
                      labelText: 'Payment Status',
                      icon: widget.participantdetails.paystatus == 'Paid'
                          ? Icons.check_circle
                          : Icons.hourglass_empty,
                      initialValue: widget.participantdetails.paystatus,
                    ),
                    SizedBox(height: constraints.height * 0.03),

                    if (widget.participantdetails.paystatus == 'Paid') ...[
                      // Chest Code
                      EventText(
                        labelText: 'Chest Code',
                        icon: Icons.abc,
                        initialValue: widget.participantdetails.chestcode,
                        readOnly: true,
                      ),
                      SizedBox(height: constraints.height * 0.03),

                      // Editable Chest Number
                      ChestField(
                        icon: Icons.confirmation_number,
                        initialNumber: widget.participantdetails.chestnumber,
                        numberController: chestNumberController,
                        isEditable: widget.participantdetails.cheststatus,
                      ),
                      SizedBox(height: constraints.height * 0.03),

                      // Update Button
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: eventctrl.issubmiting.value
                                  ? null
                                  : () {
                                      widget.participantdetails.chestnumber =
                                          chestNumberController.text.trim();
                                      eventctrl
                                          .allocateNumber(widget.participantdetails);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.buttonColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: eventctrl.issubmiting.value
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Updating...',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'Update / Mark as Participated',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            CustomColors.buttonTextColor,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: constraints.height * 0.02),

                      // Back to Scanner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              authctrl.cancelchest();
                              Get.back(result: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 60, 60, 60),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Back to Scanner',
                              style: TextStyle(
                                fontSize: 18,
                                color: CustomColors.buttonTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
