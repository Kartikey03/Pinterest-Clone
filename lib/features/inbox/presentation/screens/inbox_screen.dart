/*
 * Inbox screen with Messages and Updates sections (UI only).
 */

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Inbox',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_outlined,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Messages',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'See all',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _MessageTile(
                    avatarColor: Colors.deepOrange,
                    initial: 'P',
                    name: 'Pinterest',
                    subtitle: 'Sent a Pin',
                    trailing: '5y',
                    showPinterestLogo: true,
                    isDark: isDark,
                  ),
                  _MessageTile(
                    avatarColor: Colors.teal,
                    initial: 'A',
                    name: 'Alex Johnson',
                    subtitle: 'Great collection!',
                    trailing: '2d',
                    isDark: isDark,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.lightSurfaceVariant,
                      child: Icon(
                        Icons.person_add_outlined,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    title: Text(
                      'Find people to message',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Connect to start chatting',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                  const Divider(
                    indent: AppSpacing.lg,
                    endIndent: AppSpacing.lg,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Updates',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _UpdateTile(
                  title: "You'll love these",
                  date: '12/25',
                  color: Colors.indigo,
                  icon: Icons.favorite,
                  isDark: isDark,
                ),
                _UpdateTile(
                  title: 'Wallpapers for you',
                  date: '12/25',
                  color: Colors.blue,
                  icon: Icons.wallpaper,
                  isDark: isDark,
                ),
                _UpdateTile(
                  title: 'Love this for you',
                  date: '12/25',
                  color: Colors.pink,
                  icon: Icons.auto_awesome,
                  isDark: isDark,
                ),
                _UpdateTile(
                  title: 'These ideas are so you',
                  date: '12/25',
                  color: Colors.orange,
                  icon: Icons.lightbulb_outline,
                  isDark: isDark,
                ),
                _UpdateTile(
                  title: 'Still searching? Explore ideas',
                  date: '10/25',
                  color: Colors.teal,
                  icon: Icons.search,
                  isDark: isDark,
                  isSearchSuggestion: true,
                ),
                const SizedBox(height: AppSpacing.xxxxl),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.avatarColor,
    required this.initial,
    required this.name,
    required this.subtitle,
    required this.trailing,
    required this.isDark,
    this.showPinterestLogo = false,
  });

  final Color avatarColor;
  final String initial;
  final String name;
  final String subtitle;
  final String trailing;
  final bool isDark;
  final bool showPinterestLogo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor:
            showPinterestLogo ? AppColors.pinterestRed : avatarColor,
        child:
            showPinterestLogo
                ? const Icon(Icons.push_pin, color: AppColors.white, size: 20)
                : Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
      ),
      title: Text(
        name,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      trailing: Text(
        trailing,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
    );
  }
}

class _UpdateTile extends StatelessWidget {
  const _UpdateTile({
    required this.title,
    required this.date,
    required this.color,
    required this.icon,
    required this.isDark,
    this.isSearchSuggestion = false,
  });

  final String title;
  final String date;
  final Color color;
  final IconData icon;
  final bool isDark;
  final bool isSearchSuggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color:
              isSearchSuggestion
                  ? theme.colorScheme.surfaceContainerHighest
                  : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          icon,
          color: isSearchSuggestion ? theme.colorScheme.onSurface : color,
          size: 24,
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          children: [
            TextSpan(text: title),
            TextSpan(
              text: ' $date',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(Icons.more_horiz, color: theme.colorScheme.secondary),
      ),
    );
  }
}
