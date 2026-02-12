import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/pexels_remote_datasource.dart';

/// Concrete [PhotoRepository] implementation backed by Pexels API.
class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({PexelsRemoteDatasource? datasource})
    : _datasource = datasource ?? PexelsRemoteDatasource();

  final PexelsRemoteDatasource _datasource;

  @override
  Future<({List<Photo> photos, int? nextPage})> getCuratedPhotos(
    int page,
  ) async {
    final response = await _datasource.getCuratedPhotos(page: page);

    final photos = response.photos.map((m) => m.toEntity()).toList();

    // Pexels returns next_page URL; if null, there are no more pages.
    // We derive the next page number from current page + 1.
    final nextPage = response.nextPage != null ? page + 1 : null;

    return (photos: photos, nextPage: nextPage);
  }
}
