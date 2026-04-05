import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/feedback_provider.dart';

class MyQrCard extends ConsumerStatefulWidget {
  const MyQrCard({super.key});

  @override
  ConsumerState<MyQrCard> createState() => _MyQrCardState();
}

class _MyQrCardState extends ConsumerState<MyQrCard> {
  bool _expanded = false;

  void _toggleExpanded() {
    appHaptic(ref, type: HapticType.light);
    appSound(ref, type: SoundType.tap);
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final userDocAsync = ref.watch(currentUserDocProvider);
    final uid = ref.watch(currentUidProvider);
    return userDocAsync.when(
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (doc) {
        if (doc == null || uid == null) return const SizedBox.shrink();
        final displayName = doc['displayName'] as String? ?? 'Yo';
        final appCode = doc['appCode'] as String? ?? '------';
        final qrData = '$uid|$appCode';

        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6C63FF).withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: [
              // ── Profile header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    // Top row: avatar + name
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6C63FF), Color(0xFF5ECFB1)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + code — full width
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: appCode));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Código copiado al portapapeles')),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.tag_rounded, size: 12, color: Colors.white.withValues(alpha: 0.3)),
                                    const SizedBox(width: 3),
                                    Text(
                                      appCode,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white38,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.copy_rounded, size: 10, color: Colors.white.withValues(alpha: 0.2)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Bottom row: action buttons
                    Row(
                      children: [
                        Expanded(
                          child: _ActionChip(
                            icon: Icons.qr_code_rounded,
                            label: _expanded ? 'Ocultar QR' : 'Mi QR',
                            onTap: _toggleExpanded,
                            color: const Color(0xFF6C63FF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ActionChip(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'Escanear',
                            onTap: () {
                              appHaptic(ref, type: HapticType.light);
                              context.push('/link-friend');
                            },
                            color: const Color(0xFF5ECFB1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Expandable QR section ──
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: _QrExpanded(qrData: qrData, displayName: displayName),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.easeInOutCubicEmphasized,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color.withValues(alpha: 0.9)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QrExpanded extends StatelessWidget {
  final String qrData;
  final String displayName;

  const _QrExpanded({required this.qrData, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 160,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF0F0F1A),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF0F0F1A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Mostrá este QR a tu amigo para que te agregue',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
