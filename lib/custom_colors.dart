import 'package:dignito/services/shared_pref_service.dart';
import 'package:flutter/material.dart';
import 'package:dignito/services/local_storage_service.dart';

class CustomColors {
  // -------------------- Fixed Colors (never change) --------------------
  static const backgroundColor = Color.fromARGB(255, 224, 224, 224);
  static const errorTextColor = Colors.red;
  static const basicBlack = Colors.black;

  static const textFieldColor = Color.fromARGB(255, 238, 238, 238);
  static const textFieldBorderColor = Colors.white;
  static const textFieldFocusBorderColor = Color.fromARGB(255, 189, 189, 189);
  static const whiteCardColor = Colors.white;
  static const redCardColor = Colors.red;

  // -------------------- Default Fallback Colors --------------------
  static const DigPink = Color.fromARGB(255, 219, 42, 42);
  static const DigBlack = Color(0xFF271C22);
  static const DigYellow = Color(0xFFcdb608);
  static const DigTeal = Color(0xFF008080);
  static const regText = Color.fromARGB(255, 173, 13, 66);

  // Cached festId to avoid repeatedly calling async
  static String _festId = '1';
  static Map<String, String>? appdata;
  static Future<void> _appdata() async {
    appdata = await SharedPrefHelper.getAppData();
  }

  /// -------------------- Call Once During App Start --------------------
  static Future<void> updateRegTextColor() async {
    await _appdata(); 

    _festId =appdata!['festid'] ?? '1';
  }
  

  // -------------------- Dynamic Getters --------------------
  static Color get digPink {
    switch (_festId) {
      
      case '5': // DAKSH 2025 - Main Accent Crimson
        return const Color(0xFFB30021); // rich crimson red
      case '1': // Intense Crimson Red (Samurai Glow)
        return const Color(0xFFE40000); // Bright, almost glowing red
      default:
        return DigPink;
    }
  }

  static Color get digBlack {
    switch (_festId) {
      case '5': // Deep Matte Black (background)
        return const Color(0xFF0A0A0A);
      case '1': // Deep Black (Background/Armor)
        return const Color(0xFF000000); // Pure Black for high contrast
      default:
        return DigBlack;
    }
  }

  static Color get digYellow {
    switch (_festId) {
      case '5': // Dark warm highlight (subtle amber-red tone)
        return const Color(0xFFB86F1E);
      case '1': // Stark White/Silver (Lightning/Dragon)
        return const Color(0xFFE0E0E0); // Off-white/Silver for lightning highlights
      default:
        return DigYellow;
    }
  }

  static Color get digTeal {
    switch (_festId) {
      case '5': // Shadow red tone for dim sections
        return const Color(0xFF3C0F0F);
      case '1': // Dark Red/Maroon (Shadows/Deep Red Background)
        return const Color(0xFF4C0000); 
      default:
        return DigTeal;
    }
  }

  static Color get regTextColor {
    switch (_festId) {
      case '5': // Text: Light crimson gray (for readability)
        return const Color(0xFF8B0000);
      case '1': // Silver/Light Gray for text on black background
        return const Color(0xFFF5F5F5); // White text
      default:
        return regText;
    }
  }

  static Color get buttonColor {
    switch (_festId) {
      case '5': // Matte Red Button
        print("dd");
        return const Color(0xFF8B0000);
      case '1': // NEW: White Button (Mimicking the stark white dragon/lightning)
        print("dp");
        print(_festId);
        return Colors.white; 
      default:
        return DigPink;
    }
  }

  static Color get buttonTextColor {
    switch (_festId) {
      case '5':
        return Colors.white; // Clean contrast text on red button
      case '1':
        print("button text color is black");
        return Colors.black; // NEW: Black text on white button for contrast
        
      default:
        return Colors.white;
    }
  }

  static Color get textFieldBackground {
    switch (_festId) {
      case '5': // Subtle translucent red for inputs
        return const Color(0xFF1A0000);
      case '1': // NEW: White/Light Gray background for text fields
        return const Color(0xFFF5F5F5); // Light Gray/Off-White 
      default:
        return textFieldColor;
    }
  }

  static Color get textFieldBorder {
    switch (_festId) {
      case '5': // Deep crimson border glow
        return const Color(0xFF660000);
      case '1': // NEW: The primary Crimson Red for a light glow/accent on the border
        return const Color(0xFFE40000); 
      default:
        return textFieldBorderColor;
    }
  }
}