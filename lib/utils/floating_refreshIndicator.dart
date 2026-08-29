import 'package:flutter/material.dart';

class FloatingRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final double topOffset;
  final Color? displacementColor;
  final Color? backgroundColor;

  const FloatingRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
    this.topOffset = 16.0,
    this.displacementColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: displacementColor ?? Theme.of(context).primaryColor,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      strokeWidth: 3.0,
      displacement: topOffset,
      edgeOffset: topOffset,
      child: child,
    );
  }
}
