import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/components/button.dart';
import 'package:dignito/components/input_field.dart';
import 'package:dignito/controllers/login_controller.dart';
import 'package:dignito/custom_colors.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginCtrl = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFd02adb).withOpacity(0.8), // Darker shade with opacity
                  const Color(0xFF271C22), // Dark background color
                ],
                center: Alignment.topCenter,
                radius: 0.8,
                stops: const [0.0, 1.0],
              ),
            ),
          ),
          
          // Falling lines effect
          const FallingLines(),

          // Safe Area for the login UI
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(height: constraints.maxHeight * 0.05),

                      // Username Input Field
                      InputField(
                        labelText: 'Username',
                        icon: Icons.person,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.usernameCtrl,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),

                      // Password Input Field
                      InputField(
                        labelText: 'Password',
                        icon: Icons.lock,
                        initialValue: '',
                        onPressedCallback: loginCtrl.clearErrorMsg,
                        readOnly: false,
                        controller: loginCtrl.passwordCtrl,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),

                      // Error Message
                      SizedBox(
                        width: constraints.maxWidth * 0.8,
                        child: GetBuilder<LoginController>(
                          builder: (controller) {
                            return Text(
                              loginCtrl.errorMsg,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),

                      // Login Button
                      button(
                        'Login',
                        loginCtrl.validateInputs,
                        CustomColors.DigPink,
                      ),
                      SizedBox(height: constraints.maxHeight * 0.02),

                      const Text(
                        'Powered by dist',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Falling Lines Widget
class FallingLines extends StatefulWidget {
  const FallingLines({super.key});

  @override
  _FallingLinesState createState() => _FallingLinesState();
}

class _FallingLinesState extends State<FallingLines> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Line> _lines = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          _lines.add(Line.random()); // Add new lines over time.
          _lines.removeWhere((line) => line.opacity <= 0); // Remove faded lines.
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(_lines),
      child: Container(), // Empty container to use the custom painter
    );
  }
}

// Model for a Line
class Line {
  double x, y, length, thickness;
  double speed;
  double opacity;

  Line(this.x, this.y, this.length, this.thickness, this.speed, this.opacity);

  // Generate a random line at the top of the screen
  static Line random() {
    final random = Random();
    return Line(
      random.nextDouble() * 400, // Random x-position
      0, // Start at the top
      random.nextDouble() * 100 + 50, // Random length
      random.nextDouble() * 3 + 1, // Random thickness
      random.nextDouble() * 3 + 1, // Random speed
      1.0, // Fully visible initially
    );
  }

  // Update the line's position and opacity over time
  void update() {
    y += speed;
    opacity -= 0.01; // Gradually fade out
  }
}

// Painter to draw the lines
class LinePainter extends CustomPainter {
  final List<Line> lines;

  LinePainter(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var line in lines) {
      paint.color = Colors.white.withOpacity(line.opacity);
      paint.strokeWidth = line.thickness;
      canvas.drawLine(
        Offset(line.x, line.y),
        Offset(line.x, line.y + line.length),
        paint,
      );
      line.update(); // Update line properties for animation.
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
