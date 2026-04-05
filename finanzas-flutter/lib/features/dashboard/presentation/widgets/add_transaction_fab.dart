import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/feedback_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../transactions/presentation/widgets/add_transaction_bottom_sheet.dart';

class AddTransactionFab extends ConsumerStatefulWidget {
  const AddTransactionFab({super.key});

  @override
  ConsumerState<AddTransactionFab> createState() => _AddTransactionFabState();
}

class _AddTransactionFabState extends ConsumerState<AddTransactionFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  bool _longPressing = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails _) {
    setState(() => _longPressing = true);
    _pulseCtrl.repeat(reverse: true);
    appHaptic(ref, type: HapticType.medium);
    appSound(ref, type: SoundType.tap);
  }

  void _onLongPressEnd(LongPressEndDetails _) {
    setState(() => _longPressing = false);
    _pulseCtrl.stop();
    _pulseCtrl.reset();
    // Open directly in voice mode
    AddTransactionBottomSheet.show(context, startWithVoice: true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 85,
      ),
      child: GestureDetector(
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        child: AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, child) {
            final scale = _longPressing ? 1.0 + (_pulseCtrl.value * 0.12) : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: _longPressing
                    ? BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.colorExpense.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      )
                    : null,
                child: FloatingActionButton(
                  onPressed: () => AddTransactionBottomSheet.show(context),
                  backgroundColor: _longPressing
                      ? AppTheme.colorExpense
                      : AppTheme.colorTransfer,
                  foregroundColor: Colors.white,
                  elevation: _longPressing ? 12 : 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Icon(
                    _longPressing
                        ? Icons.mic_rounded
                        : Icons.auto_awesome_rounded,
                    size: 28,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
