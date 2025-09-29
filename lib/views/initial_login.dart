
import 'package:flutter/material.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/input_field.dart';
import 'package:get/get.dart';
import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/custom_colors.dart';

class LoginWithKey extends StatelessWidget {
  LoginWithKey({super.key});

  final LoginController loginCtrl = Get.put(LoginController());

  // Add a controller for the key input
  final TextEditingController keyCtrl = TextEditingController();

  @override





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allow the Scaffold body to resize when the keyboard appears.
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          // Ensure container takes full screen height when keyboard is not up
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            // NOTE: Ensure 'assets/splash_back.png' exists in your assets folder and pubspec.yaml
            // image: DecorationImage(
            //   image: AssetImage('assets/splash_back.png'),
            //   colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            //   fit: BoxFit.cover,
            // ),
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
            child: SingleChildScrollView( // Make content scrollable
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Ensure the scrollable content takes at least the height of the screen
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                    children: [
                      const Spacer(), // Pushes content towards center/bottom when space allows

                      // Logo
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Image.asset(
                          // NOTE: Assuming this logo exists. If not, replace or remove.
                          'assets/distlogo_login.png', 
                          height: 100, // Slightly reduced size to fit more content
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ID Input Field
                      InputField(
                        labelText: 'ID',
                        icon: Icons.badge,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.usernameCtrl,
                      ),

                      const SizedBox(height: 20),

                      // Password Input Field
                      InputField(
                        labelText: 'Password',
                        icon: Icons.lock,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.passwordCtrl,
                      ),

                      const SizedBox(height: 20),

                      // Key Input Field
                      InputField(
                        labelText: 'Key',
                        icon: Icons.vpn_key,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.keyCtrl,
                      ),

                      const SizedBox(height: 20),

                      // Error Message
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: GetBuilder<LoginController>(
                          builder: (controller) {
                            return Text(
                              loginCtrl.errorMsg,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Enter Button
                      button(
                        'Enter',
                        () {
                          // You can add your validation logic here
                          
                          loginCtrl.validateInputskey(); 
                          
                        },
                        CustomColors.regText,
                      ),
                      const SizedBox(height: 20), 
                      const Spacer(), 
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}