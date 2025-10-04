import 'package:flutter/material.dart';
import 'package:dignito/constants.dart';
import 'package:dignito/custom_colors.dart';

class InputField extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final String initialValue;
  final TextInputType keyboardType;
  final bool readOnly;
  final TextEditingController? controller;
  final Function() onPressedCallback;

  const InputField({
    super.key,
    required this.labelText,
    required this.icon,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.controller,
    required this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController effectiveController =
        controller ?? TextEditingController(text: initialValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.textFieldPadding),
      child: TextField(
        controller: effectiveController,
        keyboardType: keyboardType,
        readOnly: readOnly,
         cursorColor: CustomColors.regTextColor,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white), // White label text
          prefixIcon: Icon(
            icon,
            color: Colors.white, // White icon
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
            borderSide: const BorderSide(color: CustomColors.textFieldBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.textFieldBorderRadius),
            borderSide: const BorderSide(color: CustomColors.textFieldFocusBorderColor, width: 2.0), // Thicker border when focused
          ),
          filled: true,
          fillColor: CustomColors.regTextColor.withOpacity(0.3), // Slightly transparent fill color
        ),
        obscureText: labelText.toLowerCase() == 'password', // Mask text if label is Password
        onTap: onPressedCallback,
      ),
    );
  }
}
