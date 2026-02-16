/*
 * Shimmer loading skeleton matching the masonry grid layout with random heights.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final random = Random(42);

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBase,
      highlightColor:
          isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlight,
      child: Padding(
        padding: AppSpacing.paddingAllSm,
        child: MasonryGridView.count(
          crossAxisCount: AppConstants.masonryColumnCount,
          mainAxisSpacing: AppConstants.masonryMainAxisSpacing,
          crossAxisSpacing: AppConstants.masonryCrossAxisSpacing,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final height = 150.0 + random.nextDouble() * 150.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.shimmerBaseDark
                            : AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(
                      AppConstants.pinBorderRadius,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.shimmerBaseDark
                                : AppColors.shimmerBase,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      width: 60 + random.nextDouble() * 40,
                      height: 12,
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.shimmerBaseDark
                                : AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
