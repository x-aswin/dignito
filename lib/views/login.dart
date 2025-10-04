import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/input_field.dart';
import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/custom_colors.dart';
import 'package:dignito/services/local_storage_service.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginCtrl = Get.put(LoginController());

  // Cached Future to avoid multiple async calls
  final Future<Map<String, String>> _assetsFuture = _getFestAssetsStatic();

  // Static method to fetch assets safely
  static Future<Map<String, String>> _getFestAssetsStatic() async {
    String festid = (await LocalStorage.getValue('festid'))?.toString() ?? '1';
    print("festid in login view: $festid");
    String background = 'assets/splash_back.png';
    String logo = 'assets/dignito_logo.png';

    if (festid == '5') {
      background = 'assets/daksh_background.png';
      logo = 'assets/daksshtext.png';
      print("daksh assets loaded");
    }

    return {'background': background, 'logo': logo};
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: FutureBuilder<Map<String, String>>(
          future: _assetsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final assets = snapshot.data!;

            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(assets['background'] ?? 'assets/splash_back.png'),
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
                gradient: const RadialGradient(
                  colors: [CustomColors.regText, Color(0xFF271C22)],
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
                              assets['logo'] ?? 'assets/dignito_logo.png',
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
                          button(
                            'Login',
                            () => loginCtrl.validateInputs(),
                            CustomColors.regText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
