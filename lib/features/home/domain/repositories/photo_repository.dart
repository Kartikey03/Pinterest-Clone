import '../entities/photo.dart';

/// Abstract contract for photo data operations.
abstract class PhotoRepository {
  /// Fetch curated photos from page [page].
  ///
  /// Returns the list of photos and the next page number
  /// (or `null` if there are no more pages).
  Future<({List<Photo> photos, int? nextPage})> getCuratedPhotos(int page);
}
