/*
 * App-wide constants: API config, timeouts, cache limits, animation durations, layout values.
 */

abstract final class AppConstants {
  static const String appName = 'Pinterest';
  static const String appVersion = '1.0.0';

  static const String pexelsBaseUrl = 'https://api.pexels.com/v1/';
  static const int defaultPageSize = 20;

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 10);

  static const int maxCacheAge = 7;
  static const int maxCacheEntries = 200;

  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animHero = Duration(milliseconds: 350);

  static const int masonryColumnCount = 2;
  static const double masonryCrossAxisSpacing = 8;
  static const double masonryMainAxisSpacing = 8;
  static const double pinBorderRadius = 16;
}
