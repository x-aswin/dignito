import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_colors.dart';
import 'event_qr.dart';
import 'placement.dart';
import '../../controllers/authController.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.DigBlack,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: CustomColors.DigBlack,
        color: CustomColors.regText
         ,
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
          Icon(Icons.emoji_events, color: Colors.white),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
