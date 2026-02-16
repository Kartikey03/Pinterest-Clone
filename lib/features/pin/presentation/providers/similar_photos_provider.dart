/*
 * Provider that fetches similar photos using alt text or photographer name as search query.
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/data/datasources/pexels_remote_datasource.dart';
import '../../../home/domain/entities/photo.dart';

class SimilarPhotosNotifier extends StateNotifier<AsyncValue<List<Photo>>> {
  SimilarPhotosNotifier({
    required this.currentPhoto,
    PexelsRemoteDatasource? datasource,
  }) : _datasource = datasource ?? PexelsRemoteDatasource(),
       super(const AsyncValue.loading()) {
    _loadSimilar();
  }

  final Photo currentPhoto;
  final PexelsRemoteDatasource _datasource;

  Future<void> _loadSimilar() async {
    try {
      final query =
          currentPhoto.alt.isNotEmpty
              ? currentPhoto.alt.split(' ').take(3).join(' ')
              : currentPhoto.photographer;

      final result = await _datasource.searchPhotos(
        query: query,
        page: 1,
        perPage: 20,
      );

      final similar =
          result.photos
              .map((p) => p.toEntity())
              .where((p) => p.id != currentPhoto.id)
              .toList();

      state = AsyncValue.data(similar);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadSimilar();
  }
}

final similarPhotosProvider = StateNotifierProvider.family<
  SimilarPhotosNotifier,
  AsyncValue<List<Photo>>,
  Photo
>((ref, photo) {
  return SimilarPhotosNotifier(currentPhoto: photo);
});
