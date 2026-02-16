/*
 * Abstract photo repository contract for curated photo fetching.
 */

import '../entities/photo.dart';

abstract class PhotoRepository {
  Future<({List<Photo> photos, int? nextPage})> getCuratedPhotos(int page);
}
