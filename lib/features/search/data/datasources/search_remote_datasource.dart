/*
 * Remote datasource for Pexels photo search API.
 */

import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/network_service.dart';
import '../../../home/data/models/pexels_response_model.dart';

class SearchRemoteDatasource {
  SearchRemoteDatasource({Dio? dio})
    : _dio = dio ?? NetworkService.instance.dio;

  final Dio _dio;

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
