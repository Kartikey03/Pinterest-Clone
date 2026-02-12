import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/domain/entities/photo.dart';
import '../../data/repositories/search_repository.dart';

/// State for search results.
class SearchState {
  const SearchState({
    this.query = '',
    this.photos = const [],
    this.currentPage = 1,
    this.nextPage,
    this.isLoadingMore = false,
    this.isSearching = false,
    this.hasError = false,
    this.errorMessage,
  });

  final String query;
  final List<Photo> photos;
  final int currentPage;
  final int? nextPage;
  final bool isLoadingMore;
  final bool isSearching;
  final bool hasError;
  final String? errorMessage;

  bool get hasMore => nextPage != null;
  bool get hasResults => photos.isNotEmpty;
  bool get isEmpty => query.isNotEmpty && photos.isEmpty && !isSearching;

  SearchState copyWith({
    String? query,
    List<Photo>? photos,
    int? currentPage,
    int? Function()? nextPage,
    bool? isLoadingMore,
    bool? isSearching,
    bool? hasError,
    String? Function()? errorMessage,
  }) {
    return SearchState(
      query: query ?? this.query,
      photos: photos ?? this.photos,
      currentPage: currentPage ?? this.currentPage,
      nextPage: nextPage != null ? nextPage() : this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearching: isSearching ?? this.isSearching,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

/// Riverpod notifier managing search state with debounce.
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier({SearchRepository? repository})
    : _repository = repository ?? SearchRepository(),
      super(const SearchState());

  final SearchRepository _repository;
  Timer? _debounceTimer;

  /// Called on every keystroke. Debounces 400ms before searching.
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(query: query, isSearching: true);

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query.trim());
    });
  }

  /// Execute the search API call.
  Future<void> _performSearch(String query) async {
    try {
      final result = await _repository.searchPhotos(query: query, page: 1);
      state = SearchState(
        query: query,
        photos: result.photos,
        currentPage: 1,
        nextPage: result.nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        hasError: true,
        errorMessage: () => e.toString(),
      );
    }
  }

  /// Load next page of search results (infinite scroll).
  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingMore || state.query.isEmpty) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.searchPhotos(
        query: state.query,
        page: state.nextPage!,
      );
      state = state.copyWith(
        photos: [...state.photos, ...result.photos],
        currentPage: state.nextPage!,
        nextPage: () => result.nextPage,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: () => e.toString(),
      );
    }
  }

  /// Clear search results.
  void clear() {
    _debounceTimer?.cancel();
    state = const SearchState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Global search provider.
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  return SearchNotifier();
});
