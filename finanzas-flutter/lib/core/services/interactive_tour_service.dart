import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../widgets/tour_keys.dart';

/// Orchestrates the interactive in-app tour using tutorial_coach_mark.
/// Targets GlobalKeys from [TourKeys] and shows explanatory tooltips.
class InteractiveTourService {
  InteractiveTourService._();

  static TutorialCoachMark? _active;

  /// Shows the full tour starting at [startStep]. Calls [onFinish]
  /// when the user finishes or skips.
  static void start(
    BuildContext context, {
    int startStep = 0,
    required VoidCallback onFinish,
    required VoidCallback onSkip,
  }) {
    final targets = _buildTargets();
    if (targets.isEmpty) {
      onFinish();
      return;
    }

    _active = TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF0F0F1A),
      opacityShadow: 0.92,
      paddingFocus: 8,
      hideSkip: false,
      textSkip: 'Saltar',
      textStyleSkip: GoogleFonts.inter(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onFinish: () {
        onFinish();
        return true;
      },
      onSkip: () {
        onSkip();
        return true;
      },
    );
    _active!.show(context: context);
  }

  static void dismiss() {
    _active?.finish();
    _active = null;
  }

  static List<TargetFocus> _buildTargets() {
    return [
      _tip(
        id: 'nav_home',
        key: TourKeys.navHome,
        title: '🏠 Inicio',
        body:
            'Tu resumen diario: saldo, últimos movimientos y accesos rápidos.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'balance',
        key: TourKeys.balanceCard,
        title: '💰 Tu saldo',
        body:
            'Acá ves cuánto tenés disponible. Tocá para ver detalle por cuenta.',
        align: ContentAlign.bottom,
      ),
      _tip(
        id: 'fab',
        key: TourKeys.fab,
        title: '✨ Cargar gasto',
        body:
            'Tocá para cargar un gasto manual.\n\n👉 Truco: mantené apretado el + para abrir el dictado por voz directo.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'ai',
        key: TourKeys.aiAssistantButton,
        title: '🎤 Asistente por voz',
        body:
            'Decí "gasté 500 en el super" y la IA carga el gasto sola.\n\nTambién entiende "dividí 5000 de pizza con Juan" y crea la deuda.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'nav_tx',
        key: TourKeys.navTransactions,
        title: '📋 Movimientos',
        body:
            'Todos tus gastos e ingresos.\n\n👉 Gestos ocultos:\n• Deslizá ← para borrar\n• Doble tap para duplicar\n• Tap largo para editar rápido',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'nav_budget',
        key: TourKeys.navBudget,
        title: '📊 Presupuesto',
        body:
            'Definí un tope mensual por categoría. Te avisamos si te pasás.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'nav_goals',
        key: TourKeys.navGoals,
        title: '🎯 Metas',
        body:
            'Ahorrá para objetivos concretos y seguí el progreso visualmente.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'nav_more',
        key: TourKeys.navMore,
        title: '📂 Más',
        body:
            'Cuentas, personas, wishlist, novedades, ajustes y más.',
        align: ContentAlign.top,
      ),
      _tip(
        id: 'hidden_gestures',
        key: TourKeys.fab,
        title: '🪄 Atajos que tenés que saber',
        body:
            '• 📸 Tocá la cámara (en Cargar gasto) → escaneá un ticket\n'
            '• 🎤 Long-press en el + → voz directo\n'
            '• Deslizá ← una transacción → borrar\n'
            '• Doble tap una transacción → duplicar\n'
            '• Emoji al inicio del texto → ya asigna categoría',
        align: ContentAlign.top,
      ),
    ];
  }

  static TargetFocus _tip({
    required String id,
    required GlobalKey key,
    required String title,
    required String body,
    ContentAlign align = ContentAlign.bottom,
  }) {
    return TargetFocus(
      identify: id,
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: 16,
      contents: [
        TargetContent(
          align: align,
          builder: (ctx, controller) => _TourCard(
            title: title,
            body: body,
            onNext: controller.next,
            onPrev: controller.previous,
            onSkip: controller.skip,
          ),
        ),
      ],
    );
  }
}

class _TourCard extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onSkip;
  const _TourCard({
    required this.title,
    required this.body,
    required this.onNext,
    required this.onPrev,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(body,
              style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 13,
                  height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: onPrev,
                child: Text('Atrás',
                    style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onNext,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF5ECFB1)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Siguiente',
                      style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
