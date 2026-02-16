import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/domain/entities/photo.dart';

const _kSavedPinsKey = 'saved_pins_v1';

/// Manages saved/liked pins with full Photo objects.
///
/// Persists to SharedPreferences so saved pins survive app restarts.
class SavedPinsNotifier extends StateNotifier<Map<int, Photo>> {
  SavedPinsNotifier() : super({}) {
    _load();
  }

  /// Toggle the saved state for a photo.
  void toggle(int photoId, Photo photo) {
    if (state.containsKey(photoId)) {
      state = Map.from(state)..remove(photoId);
    } else {
      state = {...state, photoId: photo};
    }
    _persist();
  }

  /// Check if a photo is saved.
  bool isSaved(int photoId) => state.containsKey(photoId);

  /// Get all saved photos as a list (newest first).
  List<Photo> get savedPhotos => state.values.toList().reversed.toList();

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kSavedPinsKey);
    if (jsonStr == null) return;

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      final map = <int, Photo>{};
      for (final item in list) {
        final photo = Photo.fromJson(item as Map<String, dynamic>);
        map[photo.id] = photo;
      }
      state = map;
    } catch (_) {
      // Ignore corrupted data
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.values.map((p) => p.toJson()).toList();
    await prefs.setString(_kSavedPinsKey, jsonEncode(list));
  }
}

/// Global provider for saved/liked pins.
final savedPinsProvider =
    StateNotifierProvider<SavedPinsNotifier, Map<int, Photo>>((ref) {
      return SavedPinsNotifier();
    });
