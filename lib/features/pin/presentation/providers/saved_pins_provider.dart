/*
 * Manages saved/liked pins with SharedPreferences persistence.
 */

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/domain/entities/photo.dart';

const _kSavedPinsKey = 'saved_pins_v1';

class SavedPinsNotifier extends StateNotifier<Map<int, Photo>> {
  SavedPinsNotifier() : super({}) {
    _load();
  }

  void toggle(int photoId, Photo photo) {
    if (state.containsKey(photoId)) {
      state = Map.from(state)..remove(photoId);
    } else {
      state = {...state, photoId: photo};
    }
    _persist();
  }

  bool isSaved(int photoId) => state.containsKey(photoId);

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
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.values.map((p) => p.toJson()).toList();
    await prefs.setString(_kSavedPinsKey, jsonEncode(list));
  }
}

final savedPinsProvider =
    StateNotifierProvider<SavedPinsNotifier, Map<int, Photo>>((ref) {
      return SavedPinsNotifier();
    });
