import 'package:flutter/material.dart';

class OfflineUi extends StatefulWidget {
  const OfflineUi({super.key});

  @override
  State<OfflineUi> createState() => _OfflineUiState();
}

class _OfflineUiState extends State<OfflineUi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.7,
      end: 1.15,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: _animation,
        child: const Icon(
          Icons.offline_bolt_outlined,
          color: Colors.black,
          size: 48,
          semanticLabel: 'You are offline',
        ),
      ),
    );
  }
}