import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/presentation/widgets/pin_card.dart';
import '../../../home/presentation/widgets/shimmer_grid.dart';
import '../providers/search_provider.dart';
import '../widgets/category_chips.dart';
import '../widgets/trending_carousel.dart';
import '../widgets/featured_boards.dart';

/// Pinterest-style search screen.
///
/// Features replicated from the real Pinterest app:
/// - Rounded search bar at top with camera icon
/// - Trending carousel when search is empty
/// - "Ideas you might like" featured boards section
/// - Category suggestion chips
/// - Debounced search results in masonry grid
/// - Infinite scroll on search results
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.8) {
      ref.read(searchProvider.notifier).loadNextPage();
    }
  }

  void _onCategoryTap(String category) {
    _searchController.text = category;
    ref.read(searchProvider.notifier).onQueryChanged(category);
    _focusNode.unfocus();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Search Bar ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (value) {
                  ref.read(searchProvider.notifier).onQueryChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for ideas',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(searchProvider.notifier).clear();
                            },
                            icon: const Icon(Icons.close, size: 20),
                          )
                          : IconButton(
                            onPressed: () {
                              // Camera search placeholder
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Visual search coming soon!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 22,
                            ),
                          ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────
            Expanded(child: _buildContent(searchState)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SearchState state) {
    // Empty query → show discovery content
    if (state.query.isEmpty) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Trending Carousel ────────────────────────────────────
            const TrendingCarousel(),

            const SizedBox(height: AppSpacing.lg),

            // ── Featured Boards ──────────────────────────────────────
            const FeaturedBoards(),

            const SizedBox(height: AppSpacing.lg),

            // ── Category Chips ───────────────────────────────────────
            CategoryChips(onCategoryTap: _onCategoryTap),

            const SizedBox(height: AppSpacing.xxxxl),
          ],
        ),
      );
    }

    // Searching → shimmer
    if (state.isSearching && state.photos.isEmpty) {
      return const ShimmerGrid();
    }

    // No results
    if (state.isEmpty) {
      return _buildEmptyState();
    }

    // Error
    if (state.hasError && state.photos.isEmpty) {
      return _buildErrorState();
    }

    // Results grid
    return _buildResultsGrid(state);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.pinterestRed.withValues(alpha: 0.3),
          ),
          AppSpacing.gapH16,
          Text(
            'No results found',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          AppSpacing.gapH8,
          Text(
            'Try different keywords',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: AppColors.pinterestRed.withValues(alpha: 0.4),
          ),
          AppSpacing.gapH16,
          Text('Search failed', style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.gapH16,
          FilledButton.icon(
            onPressed: () {
              ref
                  .read(searchProvider.notifier)
                  .onQueryChanged(_searchController.text);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pinterestRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsGrid(SearchState state) {
    return CustomScrollView(
      controller: _scrollController,
      cacheExtent: 500,
      slivers: [
        // Results header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              'Results for "${state.query}"',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),

        // Masonry grid
        SliverPadding(
          padding: AppSpacing.paddingAllSm,
          sliver: SliverMasonryGrid.count(
            crossAxisCount: AppConstants.masonryColumnCount,
            mainAxisSpacing: AppConstants.masonryMainAxisSpacing,
            crossAxisSpacing: AppConstants.masonryCrossAxisSpacing,
            childCount: state.photos.length,
            itemBuilder: (context, index) {
              final photo = state.photos[index];
              return PinCard(
                photo: photo,
                index: index,
                onTap: () {
                  context.push('/pin/${photo.id}', extra: photo);
                },
              );
            },
          ),
        ),

        // Loading indicator
        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.pinterestRed,
                  strokeWidth: 2.5,
                ),
              ),
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxxl)),
      ],
    );
  }
}
