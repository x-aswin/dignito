import 'package:flutter/material.dart';

class ChestField extends StatelessWidget {
  final String fixedString;
  final String initialNumber;
  final IconData icon;
  final ValueChanged<int>? onChanged;
  final TextEditingController? numberController;
  final int isEditable; // 0 = read-only, anything else = editable

  const ChestField({
    super.key,
    required this.fixedString,
    required this.initialNumber,
    required this.icon,
    this.onChanged,
    this.numberController,
    required this.isEditable, // Ensure this is provided
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController effectiveController =
        numberController ?? TextEditingController(text: initialNumber);

    return TextField(
      controller: effectiveController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      readOnly: isEditable == 0, // Makes field read-only if isEditable is 0
      onChanged: (value) {
        if (onChanged != null && isEditable != 0) { // Ensure onChanged triggers only if editable
          onChanged!(int.tryParse(value) ?? 0);
        }
      },
      decoration: InputDecoration(
        prefix: Container(
          padding: const EdgeInsets.only(right: 8.0), // Add some space between text and input
          child: Text(
            fixedString,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        prefixIcon: Icon(icon, color: Colors.white), // Icon on the left
        labelText: 'Chest Number',
        labelStyle: const TextStyle(color: Colors.white), // White label text
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
          borderSide: const BorderSide(color: Colors.white), // Default border
        ),
      ),
    );
  }
}
