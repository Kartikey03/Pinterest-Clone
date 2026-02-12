import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/constants/app_constants.dart';

/// Singleton network service wrapping [Dio].
///
/// Pre-configured with Pexels API base URL, auth header,
/// timeouts, and debug-mode logging.
class NetworkService {
  NetworkService._();
  static final NetworkService _instance = NetworkService._();
  static NetworkService get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  bool _initialized = false;

  /// Must be called once during app initialization.
  Future<void> init() async {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.pexelsBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Authorization': dotenv.env['PEXELS_API_KEY'] ?? '',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Debug logging
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: false,
          logPrint: (obj) => debugPrint('📡 $obj'),
        ),
      );
    }

    _initialized = true;
  }
}
