import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Trending carousel matching Pinterest's search page hero section.
///
/// Shows a horizontally-swipeable PageView of trending topic images
/// with "Trending now" label and topic title overlaid at the bottom.
/// Tapping a topic triggers [onTopicTap] to search for that topic.
class TrendingCarousel extends StatefulWidget {
  const TrendingCarousel({super.key, this.onTopicTap});

  final void Function(String topic)? onTopicTap;

  @override
  State<TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<TrendingCarousel> {
  final _pageController = PageController(viewportFraction: 0.95);
  int _currentPage = 0;

  static const _trendingTopics = [
    _TrendingItem(
      title: 'Aesthetic Wallpapers',
      imageUrl:
          'https://images.pexels.com/photos/1261728/pexels-photo-1261728.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    _TrendingItem(
      title: 'Minimal Home Decor',
      imageUrl:
          'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    _TrendingItem(
      title: 'Travel Destinations',
      imageUrl:
          'https://images.pexels.com/photos/2325446/pexels-photo-2325446.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    _TrendingItem(
      title: 'DIY Crafts Ideas',
      imageUrl:
          'https://images.pexels.com/photos/1266302/pexels-photo-1266302.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
    _TrendingItem(
      title: 'Fashion Inspiration',
      imageUrl:
          'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=800',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Carousel ───────────────────────────────────────────────
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _trendingTopics.length,
            itemBuilder: (context, index) {
              final item = _trendingTopics[index];
              return GestureDetector(
                onTap: () => widget.onTopicTap?.call(item.title),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder:
                              (_, __) =>
                                  Container(color: AppColors.shimmerBase),
                          errorWidget:
                              (_, __, ___) => Container(
                                color: AppColors.shimmerBase,
                                child: const Icon(Icons.image_not_supported),
                              ),
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                        // Text overlay
                        Positioned(
                          left: AppSpacing.lg,
                          bottom: AppSpacing.lg,
                          right: AppSpacing.lg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trending now',
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Dots indicator ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _trendingTopics.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 8 : 6,
                height: _currentPage == index ? 8 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrendingItem {
  const _TrendingItem({required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;
}
