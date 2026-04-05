import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _finishing = false;

  late final AnimationController _floatCtrl;
  late final AnimationController _glowCtrl;

  static const _slides = [
    _Slide(
      icon: Icons.waving_hand_rounded,
      title: 'Bienvenido a Sencillo',
      description:
          'Tu app de finanzas personales. Simple, privada y poderosa. Tomá el control total de tu dinero.',
      color: Color(0xFF6C63FF),
      iconBg: Color(0xFF6C63FF),
    ),
    _Slide(
      icon: Icons.dashboard_rounded,
      title: 'Tu resumen diario',
      description:
          'En el inicio ves tu saldo total, alertas de presupuesto, gastos del mes y los últimos movimientos de un vistazo.',
      color: Color(0xFF4ECDC4),
      iconBg: Color(0xFF4ECDC4),
    ),
    _Slide(
      icon: Icons.swap_vert_rounded,
      title: 'Registrá movimientos',
      description:
          'Cargá ingresos, gastos y transferencias. Usá voz o texto con IA para registrar al instante sin formularios.',
      color: Color(0xFFFF6B6B),
      iconBg: Color(0xFFFF6B6B),
    ),
    _Slide(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Cuentas y tarjetas',
      description:
          'Gestioná todas tus cuentas: efectivo, banco, billeteras virtuales y tarjetas de crédito con control de ciclo.',
      color: Color(0xFF7C6EF7),
      iconBg: Color(0xFF7C6EF7),
    ),
    _Slide(
      icon: Icons.pie_chart_rounded,
      title: 'Presupuestos',
      description:
          'Poné límites de gasto por categoría. La app te avisa cuando estás por pasarte para que no pierdas el control.',
      color: Color(0xFFFFD93D),
      iconBg: Color(0xFFFFB347),
    ),
    _Slide(
      icon: Icons.flag_rounded,
      title: 'Metas de ahorro',
      description:
          'Creá objetivos y registrá aportes. Seguí tu progreso visual hasta cumplir cada meta.',
      color: Color(0xFF5ECFB1),
      iconBg: Color(0xFF5ECFB1),
    ),
    _Slide(
      icon: Icons.people_rounded,
      title: 'Gastos con personas',
      description:
          'Dividí gastos con amigos o familia. La app lleva la cuenta de quién debe cuánto automáticamente, como Splitwise.',
      color: Color(0xFFFF8C69),
      iconBg: Color(0xFFFF8C69),
    ),
    _Slide(
      icon: Icons.notifications_active_rounded,
      title: 'Alertas y recordatorios',
      description:
          'Recibí notificaciones de vencimientos de tarjetas, deudas pendientes y alertas de presupuesto en tu celular.',
      color: Color(0xFFE040FB),
      iconBg: Color(0xFFE040FB),
    ),
    _Slide(
      icon: Icons.cloud_done_rounded,
      title: 'Backup en la nube',
      description:
          'Tus datos se respaldan en la nube con tu cuenta de Google. Cambiás de celular y recuperás todo al instante.',
      color: Color(0xFF40C4FF),
      iconBg: Color(0xFF40C4FF),
    ),
    _Slide(
      icon: Icons.auto_awesome_rounded,
      title: '¡Todo listo!',
      description:
          'Personalizá las pestañas, el tema y las alertas desde Configuración. Tu experiencia, a tu medida.',
      color: Color(0xFF6C63FF),
      iconBg: Color(0xFF6C63FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubicEmphasized,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    if (_finishing) return;
    setState(() => _finishing = true);
    // Complete onboarding → app.dart switches to login page
    ref.read(onboardingProvider).complete();
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    final isLast = _currentPage == _slides.length - 1;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.2,
                colors: [
                  slide.color.withValues(alpha: 0.18),
                  const Color(0xFF0F0F1A),
                ],
              ),
            ),
          ),

          // Blurred glow orb
          AnimatedBuilder(
            animation: _glowCtrl,
            builder: (context, _) {
              final scale = 1.0 + _glowCtrl.value * 0.15;
              return Positioned(
                top: size.height * 0.08,
                left: size.width * 0.5 - 100 * scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  width: 200 * scale,
                  height: 200 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: slide.color.withValues(alpha: 0.10),
                    boxShadow: [
                      BoxShadow(
                        color: slide.color.withValues(alpha: 0.20),
                        blurRadius: 80,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating particles
          ...List.generate(6, (i) {
            final rng = math.Random(i * 31);
            return AnimatedBuilder(
              animation: _floatCtrl,
              builder: (context, _) {
                final baseY = size.height * 0.15 + rng.nextDouble() * size.height * 0.55;
                final y = baseY + math.sin(_floatCtrl.value * math.pi * 2 + i * 1.3) * 12;
                final x = size.width * 0.1 + rng.nextDouble() * size.width * 0.8;
                final opacity = 0.06 + rng.nextDouble() * 0.08;
                return Positioned(
                  left: x,
                  top: y,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 4 + rng.nextDouble() * 4,
                    height: 4 + rng.nextDouble() * 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: slide.color.withValues(alpha: opacity),
                    ),
                  ),
                );
              },
            );
          }),

          SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLast)
                        GestureDetector(
                          onTap: _finish,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1)),
                            ),
                            child: Text(
                              'Omitir',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return _SlidePage(slide: _slides[index]);
                    },
                  ),
                ),

                // Indicators + CTA
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      32, 20, 32, MediaQuery.of(context).padding.bottom + 28),
                  child: Column(
                    children: [
                      // Page counter
                      Text(
                        '${_currentPage + 1} / ${_slides.length}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dot indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _currentPage ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _currentPage
                                  ? slide.color
                                  : Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // CTA button
                      GestureDetector(
                        onTap: _next,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                slide.color,
                                slide.color.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: slide.color.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                isLast ? '¡Empezar!' : 'Siguiente',
                                key: ValueKey(isLast),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon in frosted glass card
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: slide.iconBg.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                      color: slide.iconBg.withValues(alpha: 0.3), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: slide.iconBg.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    slide.icon,
                    size: 56,
                    color: slide.iconBg,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 44),

          // Title
          Text(
            slide.title,
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            slide.description,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Slide {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color iconBg;

  const _Slide({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.iconBg,
  });
}
