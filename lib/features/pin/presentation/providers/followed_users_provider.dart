import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kFollowedUsersKey = 'followed_users_v1';

/// Represents a followed photographer.
class FollowedUser {
  const FollowedUser({
    required this.photographerName,
    required this.photographerUrl,
    required this.avatarInitial,
  });

  final String photographerName;
  final String photographerUrl;
  final String avatarInitial;

  Map<String, dynamic> toJson() => {
    'photographerName': photographerName,
    'photographerUrl': photographerUrl,
    'avatarInitial': avatarInitial,
  };

  factory FollowedUser.fromJson(Map<String, dynamic> json) => FollowedUser(
    photographerName: json['photographerName'] as String,
    photographerUrl: json['photographerUrl'] as String,
    avatarInitial: json['avatarInitial'] as String,
  );
}

/// Manages followed photographers.
///
/// Persists to SharedPreferences so follows survive app restarts.
class FollowedUsersNotifier extends StateNotifier<Map<String, FollowedUser>> {
  FollowedUsersNotifier() : super({}) {
    _load();
  }

  /// Toggle follow state for a photographer.
  void toggle({
    required String photographerName,
    required String photographerUrl,
  }) {
    if (state.containsKey(photographerUrl)) {
      state = Map.from(state)..remove(photographerUrl);
    } else {
      state = {
        ...state,
        photographerUrl: FollowedUser(
          photographerName: photographerName,
          photographerUrl: photographerUrl,
          avatarInitial:
              photographerName.isNotEmpty
                  ? photographerName[0].toUpperCase()
                  : '?',
        ),
      };
    }
    _persist();
  }

  /// Check if a photographer is followed.
  bool isFollowing(String photographerUrl) =>
      state.containsKey(photographerUrl);

  /// Get all followed users as a list.
  List<FollowedUser> get followedUsers => state.values.toList();

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kFollowedUsersKey);
    if (jsonStr == null) return;

    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      final map = <String, FollowedUser>{};
      for (final item in list) {
        final user = FollowedUser.fromJson(item as Map<String, dynamic>);
        map[user.photographerUrl] = user;
      }
      state = map;
    } catch (_) {
      // Ignore corrupted data
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.values.map((u) => u.toJson()).toList();
    await prefs.setString(_kFollowedUsersKey, jsonEncode(list));
  }
}

/// Global provider for followed photographers.
final followedUsersProvider =
    StateNotifierProvider<FollowedUsersNotifier, Map<String, FollowedUser>>((
      ref,
    ) {
      return FollowedUsersNotifier();
    });
