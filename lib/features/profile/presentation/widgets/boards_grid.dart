import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/board.dart';

/// Grid of boards shown in the profile's "Boards" tab.
///
/// Each board card shows a cover image (or placeholder),
/// board name, and pin count — matching Pinterest's layout.
class BoardsGrid extends StatelessWidget {
  const BoardsGrid({
    super.key,
    required this.boards,
    required this.onCreateBoard,
  });

  final List<Board> boards;
  final VoidCallback onCreateBoard;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: boards.length + 1, // +1 for "Create" button
      itemBuilder: (context, index) {
        if (index == boards.length) {
          return _CreateBoardCard(onTap: onCreateBoard);
        }
        return _BoardCard(board: boards[index]);
      },
    );
  }
}

class _BoardCard extends StatelessWidget {
  const _BoardCard({required this.board});

  final Board board;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cover Image ──────────────────────────────────────────
          Expanded(
            child:
                board.coverPhoto != null
                    ? Image.network(
                      board.coverPhoto!.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Center(
                      child: Icon(
                        Icons.dashboard_outlined,
                        size: 48,
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.4,
                        ),
                      ),
                    ),
          ),

          // ── Board Info ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        board.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (board.isPrivate)
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: theme.colorScheme.secondary,
                      ),
                  ],
                ),
                AppSpacing.gapH2,
                Text(
                  '${board.pinCount} Pins',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateBoardCard extends StatelessWidget {
  const _CreateBoardCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: theme.dividerColor,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.pinterestRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.pinterestRed,
                size: 28,
              ),
            ),
            AppSpacing.gapH8,
            Text(
              'Create board',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
