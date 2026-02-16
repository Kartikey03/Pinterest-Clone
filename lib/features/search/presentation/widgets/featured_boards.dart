/*
 * Horizontally scrollable featured boards section with image collage cards.
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class FeaturedBoards extends StatelessWidget {
  const FeaturedBoards({super.key, this.onBoardTap});

  final void Function(String boardTitle)? onBoardTap;

  static const _boards = [
    _BoardData(
      title: 'Creative school ideas',
      source: 'Crafts',
      pinCount: 45,
      images: [
        'https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/256417/pexels-photo-256417.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/301920/pexels-photo-301920.jpeg?auto=compress&cs=tinysrgb&w=400',
      ],
    ),
    _BoardData(
      title: 'Mountain escapes',
      source: 'Travel',
      pinCount: 41,
      images: [
        'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/572897/pexels-photo-572897.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/618833/pexels-photo-618833.jpeg?auto=compress&cs=tinysrgb&w=400',
      ],
    ),
    _BoardData(
      title: 'Cozy interiors',
      source: 'Home Decor',
      pinCount: 62,
      images: [
        'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/775219/pexels-photo-775219.jpeg?auto=compress&cs=tinysrgb&w=400',
      ],
    ),
    _BoardData(
      title: 'Tasty recipes',
      source: 'Food',
      pinCount: 88,
      images: [
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=400',
        'https://images.pexels.com/photos/1099680/pexels-photo-1099680.jpeg?auto=compress&cs=tinysrgb&w=400',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore featured boards',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ideas you might like',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _boards.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final board = _boards[index];
              return _BoardCard(
                board: board,
                onTap: () => onBoardTap?.call(board.title),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BoardData {
  const _BoardData({
    required this.title,
    required this.source,
    required this.pinCount,
    required this.images,
  });

  final String title;
  final String source;
  final int pinCount;
  final List<String> images;
}

class _BoardCard extends StatelessWidget {
  const _BoardCard({required this.board, this.onTap});

  final _BoardData board;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: board.images[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        placeholder:
                            (_, __) => Container(
                              color:
                                  isDark
                                      ? AppColors.shimmerBaseDark
                                      : AppColors.shimmerBase,
                            ),
                        errorWidget:
                            (_, __, ___) => Container(
                              color:
                                  isDark
                                      ? AppColors.shimmerBaseDark
                                      : AppColors.shimmerBase,
                            ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: board.images[1],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder:
                                  (_, __) => Container(
                                    color:
                                        isDark
                                            ? AppColors.shimmerBaseDark
                                            : AppColors.shimmerBase,
                                  ),
                              errorWidget:
                                  (_, __, ___) => Container(
                                    color:
                                        isDark
                                            ? AppColors.shimmerBaseDark
                                            : AppColors.shimmerBase,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: board.images[2],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder:
                                  (_, __) => Container(
                                    color:
                                        isDark
                                            ? AppColors.shimmerBaseDark
                                            : AppColors.shimmerBase,
                                  ),
                              errorWidget:
                                  (_, __, ___) => Container(
                                    color:
                                        isDark
                                            ? AppColors.shimmerBaseDark
                                            : AppColors.shimmerBase,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Text(
                        board.source,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified,
                        size: 12,
                        color: AppColors.pinterestRed,
                      ),
                    ],
                  ),
                  Text(
                    '${board.pinCount} Pins',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
