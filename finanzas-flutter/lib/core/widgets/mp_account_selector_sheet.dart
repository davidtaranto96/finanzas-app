import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/database_providers.dart';

/// Shows a bottom sheet to select which existing account to link with Mercado Pago.
/// Returns the selected account ID, or null to create a new one.
Future<String?> showMpAccountSelectorSheet(BuildContext context, WidgetRef ref) async {
  return showModalBottomSheet<String?>(
    context: context,
    backgroundColor: const Color(0xFF1E1E2C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _MpAccountSelector(),
  );
}

class _MpAccountSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsStreamProvider);
    final accounts = accountsAsync.valueOrNull ?? [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: Colors.white24, borderRadius: BorderRadius.circular(2),
            )),
            const SizedBox(height: 16),
            Text('¿Dónde importar movimientos?', style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
            )),
            const SizedBox(height: 4),
            const Text(
              'Elegí una cuenta existente o creá una nueva',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 16),

            // Create new option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00B1EA).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded, color: Color(0xFF00B1EA), size: 20),
              ),
              title: const Text('Crear cuenta nueva', style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600,
              )),
              subtitle: const Text('Se creará "Mercado Pago"',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.white.withValues(alpha: 0.04),
              onTap: () => Navigator.pop(context, null),
            ),

            if (accounts.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(color: Colors.white10),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: accounts.length,
                  itemBuilder: (ctx, i) {
                    final acc = accounts[i];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.account_balance_wallet_rounded,
                            color: Colors.white54, size: 20),
                      ),
                      title: Text(acc.name, style: const TextStyle(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500,
                      )),
                      subtitle: Text('${acc.currencyCode} · ${acc.type.name}',
                          style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () => Navigator.pop(context, acc.id),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
