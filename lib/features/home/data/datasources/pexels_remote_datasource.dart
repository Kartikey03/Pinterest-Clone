import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/network_service.dart';
import '../models/pexels_response_model.dart';

/// Remote datasource for fetching photos from the Pexels API.
///
/// Calls the curated photos endpoint with pagination.
/// This is the only class that directly interacts with the Pexels API.
class PexelsRemoteDatasource {
  PexelsRemoteDatasource({Dio? dio})
    : _dio = dio ?? NetworkService.instance.dio;

  final Dio _dio;

  /// Fetch curated photos for the given [page].
  ///
  /// Returns a parsed [PexelsResponseModel] containing
  /// the photos and pagination info.
  Future<PexelsResponseModel> getCuratedPhotos({int page = 1}) async {
    final response = await _dio.get(
      'curated',
      queryParameters: {'page': page, 'per_page': AppConstants.defaultPageSize},
    );

    return PexelsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
