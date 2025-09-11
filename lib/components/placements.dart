import 'package:flutter/material.dart';
import '../custom_colors.dart';

class placement_field extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool readonly;
  final IconData icon;

  const placement_field({
    super.key,
    required this.labelText,
    required this.controller,
    required this.readonly,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readonly,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white), // White label text
        fillColor: CustomColors.DigBlack, // Black background
        filled: true,
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded border
          borderSide: const BorderSide(color: Colors.white), // White border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded border
          borderSide: const BorderSide(color: Colors.white), // White border when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded border
          borderSide: const BorderSide(color: Colors.white), // White border when focused
        ),
      ),
      style: const TextStyle(color: Colors.white), // White text
    );
  }
}
