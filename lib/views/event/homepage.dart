import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_colors.dart';
import 'event_qr.dart';
import 'placement.dart';
import '../../controllers/authController.dart';
import '../../services/assets_manager.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final AuthController authctrl = Get.put(AuthController());
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    const EventQr(), // Page for QR scanner icon
    Placement(), // Page for events icon
  ];
  final String background = FestAssets.getBackground();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fixed background
          SizedBox.expand(
            child: Image.asset(
              background,
              fit: BoxFit.cover,
            ),
          ),
          // Optional overlay to darken background
          SizedBox.expand(
            child: Container(color: Colors.black54),
          ),
          // Foreground content
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Keep it transparent so background shows
        color: CustomColors.buttonColor,
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          Icon(Icons.qr_code_scanner_rounded, color: CustomColors.buttonTextColor),
          Icon(Icons.emoji_events, color: CustomColors.buttonTextColor),
        ],
      ),
      backgroundColor: Colors.transparent, // Scaffold background transparent
    );
  }
}
