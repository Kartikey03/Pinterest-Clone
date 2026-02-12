import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/home_feed_provider.dart';
import '../widgets/pin_card.dart';
import '../widgets/shimmer_grid.dart';

/// Pinterest-style home feed with masonry grid.
///
/// Features replicated from the real Pinterest app:
/// - Staggered masonry grid (2 columns)
/// - Infinite scroll (loads next page at 80% threshold)
/// - Pull-to-refresh (resets to page 1)
/// - Shimmer loading skeleton
/// - Scroll performance tuning (cacheExtent, keepAlives off)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Trigger next page load when scrolled to 80% of the list.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8;

    if (currentScroll >= threshold) {
      ref.read(homeFeedProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(homeFeedProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: feedState.when(
        loading: () => const ShimmerGrid(),
        error: (error, _) => _buildErrorState(context, error),
        data: (state) => _buildFeed(context, state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.push_pin, color: AppColors.pinterestRed, size: 28),
          AppSpacing.gapW8,
          Text(
            'Pinterest',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllXxl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: AppColors.pinterestRed.withValues(alpha: 0.4),
            ),
            AppSpacing.gapH16,
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Text(
              'Check your internet connection\nand try again',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH24,
            FilledButton.icon(
              onPressed:
                  () => ref.read(homeFeedProvider.notifier).loadInitial(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinterestRed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed(BuildContext context, HomeFeedState state) {
    if (state.isEmpty) {
      return const Center(child: Text('No photos found'));
    }

    return RefreshIndicator(
      color: AppColors.pinterestRed,
      onRefresh: () => ref.read(homeFeedProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        cacheExtent: 500, // Pre-render offscreen items for smooth scrolling
        slivers: [
          // ── Masonry Grid ─────────────────────────────────────────
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

          // ── Loading Indicator (infinite scroll) ──────────────────
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

          // ── Bottom Padding ──────────────────────────────────────
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxxl)),
        ],
      ),
    );
  }
}
