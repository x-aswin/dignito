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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // 👈 keeps background fixed
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // detect taps on empty areas
        onTap: () {
          FocusScope.of(context).unfocus(); // hide keyboard
        },
        child: Container(
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
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: keyboardHeight > 0 ? 150 : 0, // smooth shift
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Image.asset(
                        'assets/dignito_logo.png',
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Username Input Field
                    InputField(
                      labelText: 'Username',
                      icon: Icons.person,
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
/*
                    const SizedBox(height: 20),

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
                              width: 120,
                              child: Center(child: Text('Staff')),
                            ),
                            SizedBox(
                              width: 120,
                              child: Center(child: Text('Student')),
                            ),
                          ],
                          onPressed: (int index) {
                            loginCtrl.selectedRoleIndex.value = index;
                          },
                        ),
                      ),
                    ),

                    */

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

                    // Login Button
                    button(
                      'Login',
                      () {
                        loginCtrl.validateInputs();
                      },
                      CustomColors.regText,
                    ),
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
