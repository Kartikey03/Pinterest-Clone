/*
 * Singleton Dio network service configured for Pexels API with auth and logging.
 */

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/constants/app_constants.dart';

class NetworkService {
  NetworkService._();
  static final NetworkService _instance = NetworkService._();
  static NetworkService get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  bool _initialized = false;

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
