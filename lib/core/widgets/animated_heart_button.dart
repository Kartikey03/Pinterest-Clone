import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Animated heart/save button with scale bounce on toggle.
///
/// Replicates the satisfying "pop" effect when saving a pin
/// on Pinterest — the heart scales up briefly then settles.
class AnimatedHeartButton extends StatefulWidget {
  const AnimatedHeartButton({
    super.key,
    required this.isSaved,
    required this.onToggle,
    this.size = 22,
  });

  final bool isSaved;
  final VoidCallback onToggle;
  final double size;

  @override
  State<AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger bounce when going from unsaved → saved
    if (widget.isSaved && !oldWidget.isSaved) {
      _controller.forward(from: 0);
    }
  }

  void _onTap() {
    HapticFeedback.mediumImpact();
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isSaved ? Icons.favorite : Icons.favorite_border,
          color:
              widget.isSaved
                  ? AppColors.pinterestRed
                  : Theme.of(context).iconTheme.color,
          size: widget.size,
        ),
      ),
    );
  }
}
