import 'package:flutter/material.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/input_field.dart';
import 'package:get/get.dart';
import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/custom_colors.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginCtrl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height, // Make the container full height
        decoration: const BoxDecoration(
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
                mainAxisAlignment: MainAxisAlignment.center, // Center the content
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20), // Static height instead of based on constraints

                  // Username Input Field
                  InputField(
                    labelText: 'Username',
                    icon: Icons.person,
                    initialValue: '',
                    onPressedCallback: loginCtrl.clearErrorMsg,
                    readOnly: false,
                    controller: loginCtrl.usernameCtrl,
                  ),

                  const SizedBox(height: 20), // Static height instead of based on constraints

                  // Password Input Field
                  InputField(
                    labelText: 'Password',
                    icon: Icons.lock,
                    initialValue: '',
                    onPressedCallback: loginCtrl.clearErrorMsg,
                    readOnly: false,
                    controller: loginCtrl.passwordCtrl,
                  ),

                  const SizedBox(height: 20), // Static height instead of based on constraints

                  // Role Selection Toggle Buttons
                  Obx(
  () => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0),
    child: ToggleButtons(
      isSelected: [
        loginCtrl.selectedRoleIndex.value == 0,
        loginCtrl.selectedRoleIndex.value == 1
      ],
      borderRadius: BorderRadius.circular(10),
      fillColor: CustomColors.regText.withOpacity(0.8),
      selectedColor: Colors.white,
      color: Colors.white70,
      borderColor: Colors.white,
      selectedBorderColor: Colors.white,
      children: const [
        SizedBox(
          width: 120, // Set a fixed width for the button
          child: Center( // Center the text
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Staff'),
            ),
          ),
        ),
        SizedBox(
          width: 120, // Set a fixed width for the button
          child: Center( // Center the text
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Student'),
            ),
          ),
        ),
      ],
      onPressed: (int index) {
        loginCtrl.selectedRoleIndex.value = index;
      },
    ),
  ),
),


                  const SizedBox(height: 20), // Static height instead of based on constraints

                  // Error Message
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // Responsive width
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

                  const SizedBox(height: 20), // Static height instead of based on constraints

                  // Login Button
                  button(
                    'Login',
                    () {
                      loginCtrl.validateInputs(); // Pass role to the controller
                    },
                    CustomColors.regText,
                  ),

                  const SizedBox(height: 20), // Static height instead of based on constraints

                  const Text(
                    'Powered by Aswin S',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
