// components/textfield.dart
import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final String? initialValue; 

  const Textfield({
    super.key,
    required this.labelText,
    this.icon,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      readOnly: true,
      style: const TextStyle(color: Colors.white), // Set input text color to white
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        prefixIcon: icon != null 
            ? Icon(icon, color: Colors.white) // Set icon color to white
            : null,
        labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
      ),
    );
  }
}
