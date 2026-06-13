import 'ar.dart';
import 'en.dart';

class AppText {
  static bool isArabic = false;

  static String get(String key) {
    return isArabic ? ar[key] ?? key : en[key] ?? key;
  }
}
