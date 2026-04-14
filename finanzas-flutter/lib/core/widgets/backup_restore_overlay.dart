import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-screen overlay shown while we auto-restore a user's backup after
/// Google sign-in. Hides the raw app state behind a polished loader.
class BackupRestoreOverlay extends StatelessWidget {
  final String message;
  final bool success;
  final bool error;

  const BackupRestoreOverlay({
    super.key,
    this.message = 'Restaurando tu información...',
    this.success = false,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    if (error) {
      icon = Icons.error_outline_rounded;
      color = Colors.redAccent;
    } else if (success) {
      icon = Icons.check_circle_outline_rounded;
      color = const Color(0xFF5ECFB1);
    } else {
      icon = Icons.cloud_download_outlined;
      color = const Color(0xFF6C63FF);
    }

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: const Color(0xFF0F0F1A).withValues(alpha: 0.85),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (!success && !error)
                        const SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      Icon(icon, color: color, size: 44),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (!success && !error) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Esto tarda solo unos segundos',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
