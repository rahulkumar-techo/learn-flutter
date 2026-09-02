

import 'package:flutter/material.dart';

class SectionSurface extends StatelessWidget {
  final Widget child;

  const SectionSurface({ super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}