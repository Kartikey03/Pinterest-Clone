import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

/// Category suggestion chips shown when search is empty.
///
/// Replicates Pinterest's browse-by-category grid with
/// colored circular icons and labels.
class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.onCategoryTap});

  final void Function(String category) onCategoryTap;

  static const _categories = [
    ('Nature', Icons.park_outlined, Color(0xFF2E7D32)),
    ('Travel', Icons.flight_outlined, Color(0xFF1565C0)),
    ('Food', Icons.restaurant_outlined, Color(0xFFE65100)),
    ('Architecture', Icons.apartment_outlined, Color(0xFF4527A0)),
    ('Animals', Icons.pets_outlined, Color(0xFF6D4C41)),
    ('Fashion', Icons.checkroom_outlined, Color(0xFFAD1457)),
    ('Art', Icons.palette_outlined, Color(0xFF00838F)),
    ('Technology', Icons.devices_outlined, Color(0xFF37474F)),
    ('Fitness', Icons.fitness_center_outlined, Color(0xFFC62828)),
    ('Music', Icons.music_note_outlined, Color(0xFF6A1B9A)),
    ('Mountains', Icons.landscape_outlined, Color(0xFF33691E)),
    ('Ocean', Icons.water_outlined, Color(0xFF0277BD)),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Text(
            'Browse by category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final (name, icon, color) = _categories[index];
            return _CategoryChip(
              name: name,
              icon: icon,
              color: color,
              onTap: () => onCategoryTap(name),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          AppSpacing.gapH4,
          Text(
            name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
