import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/crypto_provider.dart';
import '../providers/stocks_provider.dart';
import '../providers/currency_preferences_provider.dart';

// ─────────────────────────────────────────────────────
// Currencies
// ─────────────────────────────────────────────────────

const kAllCurrencies = {
  'blue': ('💵', 'Dólar Blue'),
  'oficial': ('🏛️', 'Dólar Oficial'),
  'tarjeta': ('💳', 'Dólar Tarjeta'),
  'mep': ('📊', 'Dólar MEP'),
  'ccl': ('🌐', 'Dólar CCL'),
  'mayorista': ('🏭', 'Dólar Mayorista'),
  'cripto': ('₿', 'Dólar Cripto'),
};

void showCurrencySelectSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF18181F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SelectSheet(
      title: 'Elegí qué cotizaciones ver',
      accentColor: const Color(0xFF6C63FF),
      items: kAllCurrencies.entries
          .map((e) => _SelectItem(id: e.key, emoji: e.value.$1, label: e.value.$2))
          .toList(),
      selectedProvider: selectedCurrenciesProvider,
    ),
  );
}

// ─────────────────────────────────────────────────────
// Crypto
// ─────────────────────────────────────────────────────

void showCryptoSelectSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF18181F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SelectSheet(
      title: 'Elegí qué criptomonedas ver',
      accentColor: const Color(0xFFF7931A),
      items: kAvailableCryptos.entries
          .map((e) => _SelectItem(id: e.key, emoji: e.value.$1, label: '${e.value.$2} (${e.value.$3})'))
          .toList(),
      selectedProvider: selectedCryptosProvider,
    ),
  );
}

// ─────────────────────────────────────────────────────
// Stocks
// ─────────────────────────────────────────────────────

void showStocksSelectSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF18181F),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SelectSheet(
      title: 'Elegí qué acciones ver',
      accentColor: const Color(0xFF0066CC),
      items: kAvailableStocks.entries
          .map((e) => _SelectItem(
                id: e.key,
                emoji: e.value.$1,
                label: '${e.value.$2} (${e.key})',
                subtitle: e.value.$3,
              ))
          .toList(),
      selectedProvider: selectedStocksProvider,
    ),
  );
}

// ─────────────────────────────────────────────────────
// Shared sheet implementation
// ─────────────────────────────────────────────────────

class _SelectItem {
  final String id;
  final String emoji;
  final String label;
  final String? subtitle;
  const _SelectItem({required this.id, required this.emoji, required this.label, this.subtitle});
}

class _SelectSheet extends ConsumerWidget {
  final String title;
  final Color accentColor;
  final List<_SelectItem> items;
  final StateNotifierProvider<dynamic, List<String>> selectedProvider;

  const _SelectSheet({
    required this.title,
    required this.accentColor,
    required this.items,
    required this.selectedProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedProvider);
    final notifier = ref.read(selectedProvider.notifier);

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text(title,
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Text('Se muestran en la pantalla de Inicio',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: items.map((item) {
                    final isOn = selected.contains(item.id);
                    return SwitchListTile(
                      secondary: Text(item.emoji, style: const TextStyle(fontSize: 20)),
                      title: Text(item.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isOn ? FontWeight.w600 : FontWeight.w400,
                        )),
                      subtitle: item.subtitle != null
                          ? Text(item.subtitle!, style: GoogleFonts.inter(fontSize: 11, color: Colors.white30))
                          : null,
                      value: isOn,
                      activeTrackColor: accentColor.withValues(alpha: 0.4),
                      onChanged: (_) => (notifier as dynamic).toggle(item.id),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
