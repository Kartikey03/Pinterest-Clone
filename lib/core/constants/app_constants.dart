/// App-wide constants and configuration values.
abstract final class AppConstants {
  // ── App Info ───────────────────────────────────────────────────────────
  static const String appName = 'Pinterest';
  static const String appVersion = '1.0.0';

  // ── Pexels API ─────────────────────────────────────────────────────────
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1/';
  static const int defaultPageSize = 20;

  // ── Network Timeouts ──────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 10);

  // ── Cache ──────────────────────────────────────────────────────────────
  static const int maxCacheAge = 7; // days
  static const int maxCacheEntries = 200;

  // ── Animation Durations ────────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animHero = Duration(milliseconds: 350);

  // ── Layout ─────────────────────────────────────────────────────────────
  static const int masonryColumnCount = 2;
  static const double masonryCrossAxisSpacing = 8;
  static const double masonryMainAxisSpacing = 8;
  static const double pinBorderRadius = 16;
}
