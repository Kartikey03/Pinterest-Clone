import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the set of saved/liked pin IDs (local-only).
///
/// In a production app this would persist to local storage or
/// sync to a backend. For now it's in-memory only.
class SavedPinsNotifier extends StateNotifier<Set<int>> {
  SavedPinsNotifier() : super({});

  /// Toggle the saved state for a photo.
  void toggle(int photoId) {
    if (state.contains(photoId)) {
      state = {...state}..remove(photoId);
    } else {
      state = {...state, photoId};
    }
  }

  /// Check if a photo is saved.
  bool isSaved(int photoId) => state.contains(photoId);
}

/// Global provider for saved/liked pins.
final savedPinsProvider = StateNotifierProvider<SavedPinsNotifier, Set<int>>((
  ref,
) {
  return SavedPinsNotifier();
});
