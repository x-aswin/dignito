
import 'package:dignito/services/shared_pref_service.dart';

class FestAssets {
  // Store the current festid in memory
  static String festid = '2'; // default fallback

  // app start to initialize
  static Future<void> loadFestId() async {
    final appData = await SharedPrefHelper.getAppData();
    festid = appData['festid'] ?? '1';
    print("festid loaded for dynamic assets, the id is $festid");
  }

  // Map of background images
  static const Map<String, String> _backgroundImages = {
    '1': 'assets/images/splash_back.png',
    '5': 'assets/images/daksh_background.png',
  };

  // Map of logos
  static const Map<String, String> _logos = {
    '1': 'assets/images/dignito_logo.png',
    '5': 'assets/images/daksshtext.png',
  };

  // Returns the correct background image based on current festid
  static String getBackground() {
    return _backgroundImages[festid] ?? 'assets/images/default_bg.jpg';
  }

  // Returns the correct logo based on current festid
  static String getLogo() {
    return _logos[festid] ?? 'assets/images/distlogo_login.png';
  }
}
