import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/crypto_provider.dart';

class CryptoPricesCard extends ConsumerWidget {
  const CryptoPricesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPrices = ref.watch(cryptoPricesProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 0),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7931A).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.currency_bitcoin_rounded,
                      size: 16, color: Color(0xFFF7931A)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Criptomonedas',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  onTap: () => refreshCryptoPrices(ref),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.refresh_rounded,
                        size: 18, color: Colors.white38),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          asyncPrices.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Text('Error al cargar precios',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
            ),
            data: (prices) {
              if (prices.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text('Sin datos',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
                );
              }
              return SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: prices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) => _CryptoChip(price: prices[i]),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _CryptoChip extends StatelessWidget {
  final CryptoPrice price;
  const _CryptoChip({required this.price});

  @override
  Widget build(BuildContext context) {
    final isUp = price.change24h >= 0;
    final changeColor = isUp ? AppTheme.colorIncome : AppTheme.colorExpense;
    final fmt = NumberFormat.compactCurrency(symbol: '\$', decimalDigits: price.priceUsd >= 1 ? 0 : 2, locale: 'en_US');
    final changeFmt = NumberFormat('+0.0;-0.0');

    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: changeColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                kAvailableCryptos[price.id]?.$1 ?? '🪙',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(price.symbol,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            fmt.format(price.priceUsd),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 12,
                color: changeColor,
              ),
              const SizedBox(width: 3),
              Text(
                '${changeFmt.format(price.change24h)}%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: changeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
