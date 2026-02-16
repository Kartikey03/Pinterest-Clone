/*
 * PhotoRepository implementation backed by Pexels API datasource.
 */

import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/pexels_remote_datasource.dart';

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
    final nextPage = response.nextPage != null ? page + 1 : null;

    return (photos: photos, nextPage: nextPage);
  }
}
