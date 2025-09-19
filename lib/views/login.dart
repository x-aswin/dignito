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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/splash_back.png'),
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                fit: BoxFit.cover,
              ),
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 132, 13, 13),
                  Color(0xFF271C22),
                ],
                center: Alignment.topCenter,
                radius: 0.8,
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // Foreground Content (scrollable)
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 20),
                    // Username Input Field
                    InputField(
                      labelText: 'Username',
                      icon: Icons.person,
                      initialValue: 'enter username',
                      onPressedCallback: loginCtrl.clearErrorMsg,
                      readOnly: false,
                      controller: loginCtrl.usernameCtrl,
                    ),
                    const SizedBox(height: 20),
                    // Password Input Field
                    InputField(
                      labelText: 'Password',
                      icon: Icons.lock,
                      initialValue: 'enter password',
                      onPressedCallback: loginCtrl.clearErrorMsg,
                      readOnly: false,
                      controller: loginCtrl.passwordCtrl,
                    ),
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
                          fillColor: const Color.fromARGB(255, 104, 16, 28).withOpacity(0.8),
                          selectedColor: Colors.white,
                          color: Colors.white70,
                          borderColor: Colors.white,
                          selectedBorderColor: Colors.white,
                          children: const [
                            SizedBox(
                              width: 120,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text('Staff'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: Center(
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
                      const Color.fromARGB(255, 104, 16, 28),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dignito `25',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
