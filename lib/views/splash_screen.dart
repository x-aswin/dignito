import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dignito/custom_colors.dart';
import 'package:dignito/views/login.dart';


class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Increase duration for a more dramatic effect
    );

    // Create a TweenSequence for a multi-stage animation
    _animation = TweenSequence<double>([
      // Stage 1: Fast zoom out (small, quick bounce)
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.8).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: 25.0,
      ),
      // Stage 2: Crazy fast zoom in (large, bouncy effect)
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.2).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50.0,
      ),
      // Stage 3: Settle back to normal size
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.linear)),
        weight: 25.0,
      ),
    ]).animate(_controller);

    _controller.forward(); // Start the animation

    // Navigate to the next screen after a short delay
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => LoginView(),
    );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.DigBlack,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png', // Ensure this asset is in your project
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(CustomColors.regText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
