import 'ar.dart';
import 'en.dart';

class AppText {
  static bool isArabic = false;

  static void toggleLanguage() {
    isArabic = !isArabic;
  }

  static void setLanguage(bool arabic) {
    isArabic = arabic;
  }

  static String get(String key) {
    return isArabic ? ar[key] ?? key : en[key] ?? key;
  }

  static String get currentLanguage {
    return isArabic ? "العربية" : "English";
  }
}
