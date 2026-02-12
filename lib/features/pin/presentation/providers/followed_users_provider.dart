import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

/// Manages followed photographers (local-only/in-memory).
///
/// Keyed by photographer URL for uniqueness.
class FollowedUsersNotifier extends StateNotifier<Map<String, FollowedUser>> {
  FollowedUsersNotifier() : super({});

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
  }

  /// Check if a photographer is followed.
  bool isFollowing(String photographerUrl) =>
      state.containsKey(photographerUrl);

  /// Get all followed users as a list.
  List<FollowedUser> get followedUsers => state.values.toList();
}

/// Global provider for followed photographers.
final followedUsersProvider =
    StateNotifierProvider<FollowedUsersNotifier, Map<String, FollowedUser>>((
      ref,
    ) {
      return FollowedUsersNotifier();
    });
