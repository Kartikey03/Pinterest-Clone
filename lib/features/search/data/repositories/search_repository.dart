import '../../../home/domain/entities/photo.dart';
import '../datasources/search_remote_datasource.dart';

/// Repository for search operations.
class SearchRepository {
  SearchRepository({SearchRemoteDatasource? datasource})
    : _datasource = datasource ?? SearchRemoteDatasource();

  final SearchRemoteDatasource _datasource;

  /// Search photos by [query] at given [page].
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
