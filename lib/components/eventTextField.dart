import 'package:flutter/material.dart';

class EventText extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String initialValue;
  final TextInputType keyboardType;
  final bool readOnly;
  final TextEditingController? controller;

  const EventText({
    super.key,
    required this.labelText,
    required this.icon,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    bool? readOnly,
    this.controller,
  }) : readOnly = readOnly ?? true;

  @override
  Widget build(BuildContext context) {
    final TextEditingController effectiveController =
        controller ?? TextEditingController(text: initialValue);

    return TextField(
      controller: effectiveController,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white), // White label text
        prefixIcon: Icon(
          icon,
          color: Colors.white, // White icon
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white), // White border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2.0), // Thicker white border when focused
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white), // Default border color
        ),
      ),
    );
  }
}
