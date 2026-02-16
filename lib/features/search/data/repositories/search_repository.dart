/*
 * Search repository that fetches and maps photo search results from Pexels API.
 */

import '../../../home/domain/entities/photo.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepository {
  SearchRepository({SearchRemoteDatasource? datasource})
    : _datasource = datasource ?? SearchRemoteDatasource();

  final SearchRemoteDatasource _datasource;

  Future<({List<Photo> photos, int? nextPage})> searchPhotos({
    required String query,
    int page = 1,
  }) async {
    final response = await _datasource.searchPhotos(query: query, page: page);

    final photos = response.photos.map((m) => m.toEntity()).toList();
    final nextPage = response.nextPage != null ? page + 1 : null;

    return (photos: photos, nextPage: nextPage);
  }
}
