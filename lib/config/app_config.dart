import 'dart:ui';

class AppConfig {
  static const String appName = '';
  static const Size designSize = Size(428, 926);
  static const String langPath = 'assets/translations';
  static const Locale faLocale = Locale('fa', 'IR');
  static const Locale enLocale = Locale('en', 'US');
  static const Locale startLocale = faLocale;
  static const List<Locale> supportedLocales = [faLocale, enLocale];
  static const int release = 0;
  static const int feature = 1;
  static const int bugFix = 0;
  static const String preReleaseVersion = "$release.$feature.$bugFix";
}
