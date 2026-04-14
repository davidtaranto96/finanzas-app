import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/page_coach_provider.dart';
import 'page_coach_scripts.dart';

/// Muestra la guía de [pageId] si el usuario todavía no la vio.
/// Se puede invocar desde initState (con postFrameCallback) o desde
/// un onPageChanged cuando el usuario cambia de tab.
Future<void> showPageCoachIfNeeded(
    BuildContext context, WidgetRef ref, String pageId) async {
  final ctrl = ref.read(pageCoachProvider);
  if (!ctrl.isLoaded) return;
  if (ctrl.hasSeen(pageId)) return;

  final cards = kPageCoaches[pageId];
  if (cards == null || cards.isEmpty) return;

  // Marcar como visto de una (evita re-trigger si hay múltiples builds)
  await ctrl.markSeen(pageId);

  if (!context.mounted) return;
  await showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) => _PageCoachDialog(cards: cards),
  );
}

/// Muestra la guía aunque ya la haya visto (desde "Repetir tutorial").
Future<void> showPageCoachForce(BuildContext context, String pageId) {
  final cards = kPageCoaches[pageId];
  if (cards == null || cards.isEmpty) return Future.value();
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) => _PageCoachDialog(cards: cards),
  );
}

class _PageCoachDialog extends StatefulWidget {
  final List<CoachCard> cards;
  const _PageCoachDialog({required this.cards});

  @override
  State<_PageCoachDialog> createState() => _PageCoachDialogState();
}

class _PageCoachDialogState extends State<_PageCoachDialog> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < widget.cards.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _skip() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final isLast = _index == widget.cards.length - 1;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A28).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                  width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header — progress dots + skip
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(widget.cards.length, (i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 6),
                            width: i == _index ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? const Color(0xFF6C63FF)
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _skip,
                        child: Text(
                          'Saltar',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content — carousel
                SizedBox(
                  height: 320,
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemCount: widget.cards.length,
                    itemBuilder: (ctx, i) =>
                        _CoachCardView(card: widget.cards[i]),
                  ),
                ),

                // Action button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: GestureDetector(
                    onTap: _next,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF5ECFB1)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isLast ? '¡Entendido!' : 'Siguiente',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoachCardView extends StatelessWidget {
  final CoachCard card;
  const _CoachCardView({required this.card});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.emoji, style: const TextStyle(fontSize: 54)),
          const SizedBox(height: 14),
          Text(
            card.title,
            style: GoogleFonts.quicksand(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.body,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          if (card.tip != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF5ECFB1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF5ECFB1).withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Color(0xFF5ECFB1), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      card.tip!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
