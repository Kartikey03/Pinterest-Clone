import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/photo.dart';

/// Manages saved/liked pins with full Photo objects (local-only).
///
/// Stores `Map<int, Photo>` so the profile screen can display
/// saved pins as a grid of tappable images.
class SavedPinsNotifier extends StateNotifier<Map<int, Photo>> {
  SavedPinsNotifier() : super({});

  /// Toggle the saved state for a photo.
  void toggle(int photoId, Photo photo) {
    if (state.containsKey(photoId)) {
      state = Map.from(state)..remove(photoId);
    } else {
      state = {...state, photoId: photo};
    }
  }

  /// Check if a photo is saved.
  bool isSaved(int photoId) => state.containsKey(photoId);

  /// Get all saved photos as a list (newest first).
  List<Photo> get savedPhotos => state.values.toList().reversed.toList();
}

/// Global provider for saved/liked pins.
final savedPinsProvider =
    StateNotifierProvider<SavedPinsNotifier, Map<int, Photo>>((ref) {
      return SavedPinsNotifier();
    });
