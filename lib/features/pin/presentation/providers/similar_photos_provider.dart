import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/data/datasources/pexels_remote_datasource.dart';
import '../../../home/domain/entities/photo.dart';

/// Provider that fetches photos similar to a given photo.
///
/// Uses the photo's `alt` text as a search query against the Pexels API.
/// Falls back to the photographer name if alt is empty.
/// Excludes the current photo from results.
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
      // Use alt text as search query; fall back to photographer name
      final query =
          currentPhoto.alt.isNotEmpty
              ? currentPhoto.alt.split(' ').take(3).join(' ')
              : currentPhoto.photographer;

      final result = await _datasource.searchPhotos(
        query: query,
        page: 1,
        perPage: 20,
      );

      // Exclude the current photo from results
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

  /// Reload similar photos.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadSimilar();
  }
}

/// Family provider — one instance per photo ID.
final similarPhotosProvider = StateNotifierProvider.family<
  SimilarPhotosNotifier,
  AsyncValue<List<Photo>>,
  Photo
>((ref, photo) {
  return SimilarPhotosNotifier(currentPhoto: photo);
});
