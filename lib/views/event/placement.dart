// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/placements.dart';
import 'package:get/get.dart';
import 'package:dignito/controllers/EventController.dart';
import 'package:dignito/controllers/authController.dart';
import 'package:dignito/custom_colors.dart';

class Placement extends StatelessWidget {
  Placement({super.key});

  final Eventcontroller eventctrl = Get.put(Eventcontroller());
  final AuthController authctrl = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
     return WillPopScope(
      onWillPop: () async {
        authctrl.verifyLogout();
        return false;
      },
    child:  Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_back.png'),
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
          child: Center(
            child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Align to the top
                children: [
                  // Card for First Prize
                  Card(
                    color: CustomColors.DigPink.withOpacity(0.3), // Light pink color for the card
                    elevation: 8, // Adds shadow to the card
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Margin around the card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                            child:
                              placement_field(labelText: 'First Prize', controller: eventctrl.firstPrizeController, readonly: false, icon: Icons.emoji_events)
                              ),
                              SizedBox(width: 10), // Space between the field and button
                              // Circular Button
                              ElevatedButton(
                                onPressed: () {
                                 eventctrl.fetchDetails(1);
                                }, // Use verify icon
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: CustomColors.regText,
                                  padding: EdgeInsets.all(10), // Icon color
                                  shape: CircleBorder(), // Circular shape
                                  minimumSize: Size(50, 50),
                                ),
                                child: Icon(Icons.check, size: 25),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space between text fields
                          // Institution Name Field
                         placement_field(labelText: 'Institution Name', controller: eventctrl.firstPrizeinst, readonly: true,icon: Icons.school),
                          SizedBox(height: 10), // Space between text fields
                          // Members Field
                         placement_field(labelText: 'Members', controller: eventctrl.firstPrizememb, readonly: true, icon: Icons.people,)
                        ],
                      ),
                    ),
                  ),

                  // Card for Second Prize
                  Card(
                    color: CustomColors.DigPink.withOpacity(0.3), // Light pink color for the card
                    elevation: 8, // Adds shadow to the card
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Margin around the card
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child:
                                placement_field(labelText: 'Second Prize', controller: eventctrl.secondPrizeController, readonly: false,  icon: Icons.emoji_events)
                              ),
                              SizedBox(width: 10), // Space between the field and button
                              // Circular Button
                              ElevatedButton(
                                onPressed: () {
                                 eventctrl.fetchDetails(2);
                                }, // Use verify icon
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: CustomColors.regText,
                                  padding: EdgeInsets.all(10), // Icon color
                                  shape: CircleBorder(), // Circular shape
                                  minimumSize: Size(50, 50),
                                ),
                                child: Icon(Icons.check, size: 25),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space between text fields
                          // Institution Name Field
                          placement_field(labelText: 'Institution Name', controller: eventctrl.secondPrizeinst, readonly: true, icon: Icons.school),

                          SizedBox(height: 10), // Space between text fields
                          // Members Field
                          placement_field(labelText: 'Members', controller: eventctrl.secondPrizememb,readonly: true,icon: Icons.people,),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // Space before the button

                  // Submit Button
                  button(
                    'Submit',
                    () {
                      eventctrl.postPlacements();
                    },
                    CustomColors.regText,
                  ),

                  const SizedBox(height: 20), // Space below the button
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
