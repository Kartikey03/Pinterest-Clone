/*
 * Data model for the Pexels curated/search API response with pagination info.
 */

import 'photo_model.dart';

class PexelsResponseModel {
  const PexelsResponseModel({
    required this.page,
    required this.perPage,
    required this.totalResults,
    required this.photos,
    this.nextPage,
  });

  final int page;
  final int perPage;
  final int totalResults;
  final String? nextPage;
  final List<PhotoModel> photos;

  factory PexelsResponseModel.fromJson(Map<String, dynamic> json) {
    return PexelsResponseModel(
      page: json['page'] as int,
      perPage: json['per_page'] as int,
      totalResults: json['total_results'] as int,
      nextPage: json['next_page'] as String?,
      photos:
          (json['photos'] as List<dynamic>)
              .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
