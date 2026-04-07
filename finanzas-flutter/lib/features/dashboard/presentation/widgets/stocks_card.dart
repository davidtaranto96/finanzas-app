import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/stocks_provider.dart';

class StocksCard extends ConsumerWidget {
  const StocksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPrices = ref.watch(stockPricesProvider);

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
                    color: const Color(0xFF0066CC).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.show_chart_rounded,
                      size: 16, color: Color(0xFF0066CC)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Acciones',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  onTap: () => refreshStockPrices(ref),
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
              child: Text('Error al cargar acciones',
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
                  itemBuilder: (ctx, i) => _StockChip(stock: prices[i]),
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

class _StockChip extends StatelessWidget {
  final StockPrice stock;
  const _StockChip({required this.stock});

  @override
  Widget build(BuildContext context) {
    final isUp = stock.changePercent >= 0;
    final changeColor = isUp ? AppTheme.colorIncome : AppTheme.colorExpense;
    final priceFmt = stock.price >= 1000
        ? NumberFormat.compact(locale: 'en_US')
        : NumberFormat('#,##0.00', 'en_US');
    final changeFmt = NumberFormat('+0.0;-0.0');
    final info = kAvailableStocks[stock.symbol];

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
              Text(info?.$1 ?? '📊', style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(stock.symbol,
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
            stock.price > 0
                ? '\$${priceFmt.format(stock.price)}'
                : '—',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          if (stock.price > 0)
            Row(
              children: [
                Icon(
                  isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  size: 12,
                  color: changeColor,
                ),
                const SizedBox(width: 3),
                Text(
                  '${changeFmt.format(stock.changePercent)}%',
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
