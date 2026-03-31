import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/providers/mock_data_provider.dart'; // For MonthlyBalance model
import '../widgets/balance_hero_card.dart';
import '../widgets/card_alert_banner.dart';
import '../widgets/accounts_row.dart';
import '../widgets/recent_transactions_list.dart';
import '../widgets/quick_stats_row.dart';
import '../widgets/add_transaction_fab.dart';
import '../../../transactions/domain/models/transaction.dart' as dom_tx;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    
    // Real Data Streams
    final accountsAsync = ref.watch(accountsStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final syncStatus = ref.watch(_syncTimerProvider);
    final isSyncing = syncStatus.isLoading;
    
    return accountsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (accounts) {
        return transactionsAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
          data: (transactions) {
            // Brain Calculation Logic
            if (accounts.isEmpty) {
              return Scaffold(
                body: Center(
                  child: Text('No hay cuentas', style: GoogleFonts.inter(fontSize: 16, color: cs.onSurfaceVariant)),
                ),
              );
            }

            final arsCash = accounts.where((a) => a.currencyCode == 'ARS' && !a.isCreditCard)
                                   .fold(0.0, (sum, a) => sum + a.balance);
            final mcAccount = accounts.firstWhere((a) => a.id == 'mc_credit', orElse: () => accounts[0]);
            final visaAccount = accounts.firstWhere((a) => a.id == 'visa_credit', orElse: () => accounts[0]);

            final safeBudget = arsCash - (mcAccount.balance + visaAccount.balance + 317000);
            
            // Calculate real MonthlyBalance for widgets
            final now = DateTime.now();
            final currentMonthTxs = transactions.where((t) => t.date.month == now.month && t.date.year == now.year).toList();
            final income = currentMonthTxs.where((t) => t.type == dom_tx.TransactionType.income).fold(0.0, (sum, t) => sum + t.amount);
            final expense = currentMonthTxs.where((t) => t.type == dom_tx.TransactionType.expense).fold(0.0, (sum, t) => sum + t.amount);
            
            final monthlyStats = MonthlyBalance(
              income: income, 
              expense: expense, 
              pendingToRecover: 0,
            );
            
            final monthName = DateFormat('MMMM yyyy', 'es').format(now);

            return Scaffold(
              backgroundColor: cs.surface,
              body: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        backgroundColor: cs.surface,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Finanzas', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700)),
                            Text(monthName, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant)),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () => _AlertsBottomSheet.show(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () => context.push('/settings'),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 8),
                            BalanceHeroCard(
                              balance: monthlyStats, 
                              safeBudget: safeBudget,
                            ),
                            const SizedBox(height: 12),

                            if (visaAccount.balance > 0)
                              CardAlertBanner(
                                cardName: 'Visa Signature',
                                amount: visaAccount.balance,
                                dueDate: DateTime(2026, 4, 3),
                                closingDate: DateTime(2026, 3, 20),
                              ),
                            
                            if (mcAccount.balance > 0)
                              CardAlertBanner(
                                cardName: 'Mastercard Black',
                                amount: mcAccount.balance,
                                dueDate: DateTime(2026, 4, 8),
                                closingDate: DateTime(2026, 3, 26),
                              ),
                            
                            const SizedBox(height: 12),
                            QuickStatsRow(balance: monthlyStats),
                            const SizedBox(height: 20),

                            _SectionHeader(
                              title: 'Mis cuentas',
                              actionLabel: 'Ver todas',
                              onAction: () => context.push('/accounts'),
                            ),
                            const SizedBox(height: 8),
                            AccountsRow(accounts: accounts),
                            const SizedBox(height: 20),

                            _SectionHeader(
                              title: 'Movimientos detallados',
                              actionLabel: 'Ver todos',
                              onAction: () => context.push('/transactions'),
                            ),
                            const SizedBox(height: 8),
                            RecentTransactionsList(transactions: transactions.take(10).toList()),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  
                  if (isSyncing)
                    const _SyncLoadingOverlay(progress: 0.8),
                ],
              ),
              floatingActionButton: isSyncing ? null : const AddTransactionFab(),
            );
          },
        );
      },
    );
  }
}

// Clean sync timer without circularity
final _syncTimerProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 2));
});

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionHeader({required this.title, required this.actionLabel, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onAction, child: Text(actionLabel, style: TextStyle(color: AppTheme.colorTransfer))),
      ],
    );
  }
}

class _SyncLoadingOverlay extends StatelessWidget {
  final double progress;
  const _SyncLoadingOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.colorTransfer),
            const SizedBox(height: 16),
            Text('Sincronizando con base de datos...', style: GoogleFonts.inter(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _AlertsBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Notificaciones', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('No hay alertas nuevas.', style: TextStyle(color: Colors.white38)),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
