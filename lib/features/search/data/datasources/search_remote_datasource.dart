import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/network_service.dart';
import '../../../home/data/models/pexels_response_model.dart';

/// Remote datasource for searching photos via Pexels API.
///
/// Calls `GET /v1/search?query=...&page=N&per_page=20`.
/// Reuses models from the home feature since the response
/// format is identical to the curated endpoint.
class SearchRemoteDatasource {
  SearchRemoteDatasource({Dio? dio})
    : _dio = dio ?? NetworkService.instance.dio;

  final Dio _dio;

  /// Search for photos matching [query].
  Future<PexelsResponseModel> searchPhotos({
    required String query,
    int page = 1,
  }) async {
    final response = await _dio.get(
      'search',
      queryParameters: {
        'query': query,
        'page': page,
        'per_page': AppConstants.defaultPageSize,
      },
    );

    return PexelsResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
