import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/input_field.dart';
import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/custom_colors.dart';
import 'package:dignito/services/assets_manager.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginCtrl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    // Get assets synchronously from memory
    final String background = FestAssets.getBackground();
    final String logo = FestAssets.getLogo();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  Colors.black54, BlendMode.darken),
            ),
            gradient:  RadialGradient(
              colors: [CustomColors.regTextColor, Color(0xFF271C22)],
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
                padding: EdgeInsets.only(bottom: keyboardInset),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Image.asset(
                          logo,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        labelText: 'Username',
                        icon: Icons.person,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.usernameCtrl,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        labelText: 'Password',
                        icon: Icons.lock,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.passwordCtrl,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: GetBuilder<LoginController>(
                          builder: (_) => Text(
                            loginCtrl.errorMsg,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
  if (loginCtrl.isLoading.value) {
    return Column(
      children: const [
        CircularProgressIndicator(color: Colors.white),
        SizedBox(height: 10),
        Text(
          'Hold tight, we are on it...',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  } else {
    return button(
      'Login',
      () {
        loginCtrl.validateInputs();
      },
      CustomColors.buttonColor.withOpacity(0.8),
    );
  }
}),

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
