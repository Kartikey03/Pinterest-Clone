/*
 * Image and data caching service with custom cache managers for thumbnails and full images.
 */

import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  CacheService._();
  static final CacheService _instance = CacheService._();
  static CacheService get instance => _instance;

  static const int _maxNrOfCacheObjects = 200;
  static const Duration _stalePeriod = Duration(days: 7);

  static final CacheManager thumbnailCacheManager = CacheManager(
    Config(
      'pinterestThumbnails',
      maxNrOfCacheObjects: _maxNrOfCacheObjects,
      stalePeriod: _stalePeriod,
    ),
  );

  static final CacheManager fullImageCacheManager = CacheManager(
    Config(
      'pinterestFullImages',
      maxNrOfCacheObjects: 50,
      stalePeriod: const Duration(days: 3),
    ),
  );

  Future<void> init() async {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20;
    PaintingBinding.instance.imageCache.maximumSize = 200;
  }

  Future<void> evict(String url) async {
    await thumbnailCacheManager.removeFile(url);
    await fullImageCacheManager.removeFile(url);
  }

  Future<void> clearAll() async {
    await thumbnailCacheManager.emptyCache();
    await fullImageCacheManager.emptyCache();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
