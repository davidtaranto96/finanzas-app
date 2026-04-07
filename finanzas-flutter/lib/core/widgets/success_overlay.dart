import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Animated green checkmark overlay shown after a successful transaction.
class SuccessOverlay {
  SuccessOverlay._();

  /// Shows the overlay and returns a Future that completes after the animation.
  static Future<void> show(BuildContext context) {
    final completer = Completer<void>();
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _SuccessAnimation(
        onDone: () {
          entry.remove();
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    overlay.insert(entry);
    return completer.future;
  }
}

class _SuccessAnimation extends StatefulWidget {
  final VoidCallback onDone;
  const _SuccessAnimation({required this.onDone});

  @override
  State<_SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<_SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _ctrl.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      // Fade out
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return IgnorePointer(
          child: Container(
            color: Colors.black.withValues(alpha: 0.25 * _opacity.value),
            child: Center(
              child: Transform.scale(
                scale: _scale.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                            blurRadius: 28,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
