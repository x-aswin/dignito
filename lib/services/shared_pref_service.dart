import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For base64Decode
import 'dart:typed_data'; // For Uint8List

class SharedPrefHelper {
  static Future<void> saveAppData({
    required String appKey,
    required String appTitle,
    required String logoData,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('appKey', appKey);
    await prefs.setString('appTitle', appTitle);
    await prefs.setString('logoData', logoData);
  }


  static Future<Map<String, String>> getAppData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return {
      'appKey': prefs.getString('appKey') ?? '',
      'appTitle': prefs.getString('appTitle') ?? '',
      'logoData': prefs.getString('logoData') ?? '',
    };
  }


   // Get appKey from SharedPreferences
  static Future<String> getAppKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('appKey') ?? '';
  }

  // Get appTitle from SharedPreferences
  static Future<String> getAppTitle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('appTitle') ?? '';
  }




  // Convert Base64 image data to binary (Uint8List)
  static Future<Uint8List> getLogoImageBinary() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Get the Base64 string stored in SharedPreferences
    String base64String = prefs.getString('logoData') ?? '';
    
    if (base64String.isEmpty) {
      print("No logo data found in SharedPreferences.");
    }
    
    // Convert Base64 string to binary data
    return base64Decode(base64String); // Returns a Uint8List (binary data)
  }
}
