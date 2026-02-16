/*
 * Riverpod notifier for home feed: initial load, pagination, refresh, and photo removal.
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/photo_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';

class HomeFeedState {
  const HomeFeedState({
    this.photos = const [],
    this.currentPage = 1,
    this.nextPage,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
  });

  final List<Photo> photos;
  final int currentPage;
  final int? nextPage;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;

  bool get hasMore => nextPage != null;
  bool get isEmpty => photos.isEmpty && !isLoadingMore;

  HomeFeedState copyWith({
    List<Photo>? photos,
    int? currentPage,
    int? Function()? nextPage,
    bool? isLoadingMore,
    bool? hasError,
    String? Function()? errorMessage,
  }) {
    return HomeFeedState(
      photos: photos ?? this.photos,
      currentPage: currentPage ?? this.currentPage,
      nextPage: nextPage != null ? nextPage() : this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class HomeFeedNotifier extends StateNotifier<AsyncValue<HomeFeedState>> {
  HomeFeedNotifier({PhotoRepository? repository})
    : _repository = repository ?? PhotoRepositoryImpl(),
      super(const AsyncValue.loading()) {
    loadInitial();
  }

  final PhotoRepository _repository;

  Future<void> loadInitial() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.getCuratedPhotos(1);
      state = AsyncValue.data(
        HomeFeedState(
          photos: result.photos,
          currentPage: 1,
          nextPage: result.nextPage,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final result = await _repository.getCuratedPhotos(current.nextPage!);
      state = AsyncValue.data(
        current.copyWith(
          photos: [...current.photos, ...result.photos],
          currentPage: current.nextPage!,
          nextPage: () => result.nextPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        current.copyWith(
          isLoadingMore: false,
          hasError: true,
          errorMessage: () => e.toString(),
        ),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final result = await _repository.getCuratedPhotos(1);
      state = AsyncValue.data(
        HomeFeedState(
          photos: result.photos,
          currentPage: 1,
          nextPage: result.nextPage,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void removePhoto(int photoId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        photos: current.photos.where((p) => p.id != photoId).toList(),
      ),
    );
  }
}

final homeFeedProvider =
    StateNotifierProvider<HomeFeedNotifier, AsyncValue<HomeFeedState>>((ref) {
      return HomeFeedNotifier();
    });
