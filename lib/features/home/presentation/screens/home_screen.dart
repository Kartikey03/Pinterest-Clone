import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/domain/entities/photo.dart';
import '../../../pin/presentation/providers/saved_pins_provider.dart';
import '../providers/home_feed_provider.dart';
import '../widgets/pin_card.dart';
import '../widgets/shimmer_grid.dart';

/// Pinterest-style home feed with "For You" + "Saved" tabs.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  int _activeTabIndex = 0;

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

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.8) {
      ref.read(homeFeedProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(homeFeedProvider);
    final savedPins = ref.watch(savedPinsProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Tab Row: "For you" + "Saved" ───────────────────────────
            _buildTabRow(context),

            // ── Feed Content ───────────────────────────────────────────
            Expanded(
              child:
                  _activeTabIndex == 0
                      ? feedState.when(
                        data: (state) => _buildForYouFeed(state),
                        loading: () => const ShimmerGrid(),
                        error: (error, _) => _buildErrorView(),
                      )
                      : _buildSavedFeed(savedPins),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabRow(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = ['For you', 'Saved'];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Tab labels
          Expanded(
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isActive = _activeTabIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTabIndex = index),
                    child: Text(
                      tabs[index],
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.w500,
                        color:
                            isActive
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Filter icon
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.tune,
              color: theme.colorScheme.onSurface,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
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
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppSpacing.gapH16,
          FilledButton.icon(
            onPressed: () => ref.read(homeFeedProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Try again'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pinterestRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouFeed(HomeFeedState state) {
    if (state.photos.isEmpty) {
      return const Center(child: Text('No photos found'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(homeFeedProvider.notifier).refresh(),
      color: AppColors.pinterestRed,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 500,
        slivers: [
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
      ),
    );
  }

  Widget _buildSavedFeed(Map<int, Photo> savedPins) {
    final photos = savedPins.values.toList().reversed.toList();

    if (photos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: AppColors.pinterestRed.withValues(alpha: 0.3),
            ),
            AppSpacing.gapH16,
            Text(
              'No saved pins yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Text(
              'Tap the save icon on any pin to save it',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      cacheExtent: 500,
      slivers: [
        SliverPadding(
          padding: AppSpacing.paddingAllSm,
          sliver: SliverMasonryGrid.count(
            crossAxisCount: AppConstants.masonryColumnCount,
            mainAxisSpacing: AppConstants.masonryMainAxisSpacing,
            crossAxisSpacing: AppConstants.masonryCrossAxisSpacing,
            childCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
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
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxxl)),
      ],
    );
  }
}
