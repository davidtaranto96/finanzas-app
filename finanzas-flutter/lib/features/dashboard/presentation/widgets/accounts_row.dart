import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/accounts/domain/models/account.dart';
import '../../../../core/utils/format_utils.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/mercado_pago_provider.dart';

class AccountsRow extends ConsumerWidget {
  final List<Account> accounts;
  const AccountsRow({super.key, required this.accounts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mpLinkedId = ref.watch(mpLinkedAccountIdProvider).valueOrNull;

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: accounts.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == accounts.length) {
            return _AddAccountCard();
          }
          final acc = accounts[index];
          if (mpLinkedId != null && acc.id == mpLinkedId) {
            return _MpAccountCard(account: acc);
          }
          return _AccountCard(account: acc);
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  const _AccountCard({required this.account});

  IconData get _icon {
    switch (account.type) {
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.credit:
        return Icons.credit_card_rounded;
      case AccountType.cash:
        return Icons.payments_rounded;
      case AccountType.savings:
        return Icons.savings_rounded;
      case AccountType.investment:
        return Icons.trending_up_rounded;
    }
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return AppTheme.colorTransfer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = account.color != null
        ? _parseColor(account.color!)
        : AppTheme.colorTransfer;

    return GestureDetector(
      onTap: () => context.push('/accounts/${account.id}'),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.2),
              cs.surfaceContainerHigh,
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_icon, size: 14, color: color),
                ),
                if (account.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Principal',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatAmount(account.isCreditCard
                      ? account.availableCredit
                      : account.balance),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                if (account.isCreditCard)
                  Text(
                    'Disponible',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          color: AppTheme.colorIncome,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mercado Pago branded card ──────────────────────────────────────────────

class _MpAccountCard extends StatelessWidget {
  final Account account;
  const _MpAccountCard({required this.account});

  static const _mpBlue = Color(0xFF009EE3);
  static const _mpLightBlue = Color(0xFF00B1EA);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/accounts/${account.id}'),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_mpBlue, _mpLightBlue],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _mpBlue.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      size: 14, color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'MP',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatAmount(account.balance),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/accounts'),
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: cs.outlineVariant,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: cs.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              'Agregar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.primary,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
