/*
 * Pinterest-style refresh indicator with spinning logo on pull-to-refresh.
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PinterestRefreshIndicator extends StatefulWidget {
  const PinterestRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.scrollController,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  @override
  State<PinterestRefreshIndicator> createState() =>
      _PinterestRefreshIndicatorState();
}

class _PinterestRefreshIndicatorState extends State<PinterestRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _bounceController;
  bool _isRefreshing = false;
  double _dragOffset = 0.0;
  static const double _triggerDistance = 100.0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_isRefreshing) return false;

    if (notification is OverscrollNotification) {
      if (notification.overscroll < 0) {
        setState(() {
          _dragOffset += notification.overscroll.abs();
        });
      }
    }

    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels <= 0 && _dragOffset > 0) {
        setState(() {
          _dragOffset = math.max(
            0,
            _dragOffset + (notification.scrollDelta ?? 0).abs() * -1,
          );
        });
      }
    }

    if (notification is ScrollEndNotification && _dragOffset > 0) {
      if (_dragOffset >= _triggerDistance) {
        _startRefresh();
      } else {
        setState(() {
          _dragOffset = 0;
        });
      }
    }

    return false;
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    _spinController.repeat();

    await widget.onRefresh();

    _spinController.stop();
    _spinController.reset();
    setState(() {
      _isRefreshing = false;
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final showIndicator = _dragOffset > 0 || _isRefreshing;
    final progress = (_dragOffset / _triggerDistance).clamp(0.0, 1.0);

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Stack(
        children: [
          widget.child,
          if (showIndicator)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: _isRefreshing ? 12 : (progress * 40),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _isRefreshing ? 1.0 : progress,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: RotationTransition(
                            turns:
                                _isRefreshing
                                    ? _spinController
                                    : AlwaysStoppedAnimation(progress * 0.5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                'assets/images/pinterest_logo.jpg',
                                width: 28,
                                height: 28,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
