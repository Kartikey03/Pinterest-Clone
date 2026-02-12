import 'package:flutter/painting.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Manages image and data caching configuration.
///
/// Performance optimizations:
/// - Custom cache manager with size and age limits
/// - Separate cache key for thumbnails vs full images
/// - Pre-warming for images about to scroll into view
class CacheService {
  CacheService._();
  static final CacheService _instance = CacheService._();
  static CacheService get instance => _instance;

  /// Maximum number of images to keep in file cache.
  static const int _maxNrOfCacheObjects = 200;

  /// Maximum age of cached images before eviction.
  static const Duration _stalePeriod = Duration(days: 7);

  /// Custom cache manager for pin thumbnails (smaller images, more of them).
  static final CacheManager thumbnailCacheManager = CacheManager(
    Config(
      'pinterestThumbnails',
      maxNrOfCacheObjects: _maxNrOfCacheObjects,
      stalePeriod: _stalePeriod,
    ),
  );

  /// Custom cache manager for full-resolution images (fewer, larger).
  static final CacheManager fullImageCacheManager = CacheManager(
    Config(
      'pinterestFullImages',
      maxNrOfCacheObjects: 50,
      stalePeriod: const Duration(days: 3),
    ),
  );

  /// Initialize caching — set CachedNetworkImage defaults.
  Future<void> init() async {
    // Set the default cache manager for CachedNetworkImage
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
    PaintingBinding.instance.imageCache.maximumSize =
        200; // 200 images in memory
  }

  /// Evict a specific URL from all caches.
  Future<void> evict(String url) async {
    await thumbnailCacheManager.removeFile(url);
    await fullImageCacheManager.removeFile(url);
  }

  /// Clear all caches.
  Future<void> clearAll() async {
    await thumbnailCacheManager.emptyCache();
    await fullImageCacheManager.emptyCache();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}
