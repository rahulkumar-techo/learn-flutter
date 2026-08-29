import 'package:flutter/material.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const HeaderDelegate({required this.child});

  static const double _height = 126;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // Sets the background color to solid white
        color: Colors.white,
       
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant HeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
