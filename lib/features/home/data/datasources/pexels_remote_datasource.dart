/*
 * Pexels API remote datasource for curated and searched photos.
 */

import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/network_service.dart';
import '../models/pexels_response_model.dart';

class PexelsRemoteDatasource {
  PexelsRemoteDatasource({Dio? dio})
    : _dio = dio ?? NetworkService.instance.dio;

  final Dio _dio;

  Future<PexelsResponseModel> getCuratedPhotos({int page = 1}) async {
    final response = await _dio.get(
      'curated',
      queryParameters: {'page': page, 'per_page': AppConstants.defaultPageSize},
    );

    return PexelsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PexelsResponseModel> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get(
      'search',
      queryParameters: {'query': query, 'page': page, 'per_page': perPage},
    );

    return PexelsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
