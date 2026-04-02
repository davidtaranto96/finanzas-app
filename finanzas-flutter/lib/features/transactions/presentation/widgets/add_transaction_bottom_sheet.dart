import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/logic/transaction_service.dart';
import '../../../../core/logic/account_service.dart';
import '../../../../core/logic/people_service.dart';
import '../../../../core/logic/ai_transaction_parser.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/models/nl_transaction.dart';
import '../../domain/models/transaction.dart';
import '../../../accounts/domain/models/account.dart' as dom_acc;
import '../../../people/domain/models/person.dart' as dom_p;
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';

// ─────────────────────────────────────────────────────────
// Mapa de íconos y colores por categoría (compartido con tiles)
// ─────────────────────────────────────────────────────────
const Map<String, IconData> kCategoryIcons = {
  'food': Icons.restaurant_rounded,
  'transport': Icons.directions_car_rounded,
  'health': Icons.local_hospital_rounded,
  'entertainment': Icons.movie_rounded,
  'shopping': Icons.shopping_bag_rounded,
  'home': Icons.home_rounded,
  'education': Icons.school_rounded,
  'services': Icons.bolt_rounded,
  'salary': Icons.work_rounded,
  'freelance': Icons.laptop_rounded,
  'transfer': Icons.swap_horiz_rounded,
  'cat_alim': Icons.local_grocery_store_rounded,
  'cat_transp': Icons.local_gas_station_rounded,
  'cat_entret': Icons.sports_esports_rounded,
  'cat_salud': Icons.favorite_rounded,
  'cat_financial': Icons.payments_rounded,
  'cat_peer_to_peer': Icons.people_rounded,
  'other_expense': Icons.receipt_long_rounded,
  'other_income': Icons.attach_money_rounded,
};

const Map<String, String> kCategoryEmojis = {
  'food': '🍔',
  'transport': '🚗',
  'health': '🏥',
  'entertainment': '🎬',
  'shopping': '🛍️',
  'home': '🏠',
  'education': '📚',
  'services': '🔌',
  'salary': '💼',
  'freelance': '💻',
  'transfer': '🔄',
  'cat_alim': '🛒',
  'cat_transp': '⛽',
  'cat_entret': '🎮',
  'cat_salud': '❤️',
  'cat_financial': '💳',
  'cat_peer_to_peer': '👥',
  'other_expense': '💸',
  'other_income': '💰',
};

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  const AddTransactionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionBottomSheet(),
    );
  }

  @override
  ConsumerState<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends ConsumerState<AddTransactionBottomSheet> {
  // Mode
  bool _isSmart = true;

  // Manual form
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  TransactionType _type = TransactionType.expense;
  String _selectedCategoryId = 'food';
  dom_acc.Account? _selectedAccount;

  // AI form
  final _aiController = TextEditingController();
  bool _isAnalyzing = false;
  NLTransaction? _parsed;         // resultado del parsing
  bool _showConfirmation = false;  // mostrar tarjeta de confirmación

  // Voice
  final SpeechToText _speech = SpeechToText();
  bool _speechAvailable = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (e) => setState(() => _isListening = false),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
          if (_aiController.text.isNotEmpty) _processAiInput();
        }
      },
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _speech.stop();
    _amountController.dispose();
    _titleController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // Voz
  // ─────────────────────────────────────────────
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      if (_aiController.text.isNotEmpty) _processAiInput();
      return;
    }

    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Micrófono no disponible en este dispositivo')),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _aiController.clear();
      _parsed = null;
      _showConfirmation = false;
    });

    await _speech.listen(
      onResult: (result) {
        setState(() => _aiController.text = result.recognizedWords);
      },
      localeId: 'es_AR',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  // ─────────────────────────────────────────────
  // Procesamiento IA
  // ─────────────────────────────────────────────
  Future<void> _processAiInput() async {
    final text = _aiController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
      _showConfirmation = false;
      _parsed = null;
    });

    final accounts = ref.read(accountsStreamProvider).value ?? [];
    final people = ref.read(peopleStreamProvider).value ?? [];
    final goals = ref.read(activeGoalsProvider);
    final wishlist = ref.read(mockWishlistProvider);

    try {
      final result = await ref.read(aiTransactionParserProvider).parse(
        input: text,
        accounts: accounts,
        people: people,
        goals: goals,
        wishlist: wishlist,
      );

      if (mounted) {
        setState(() {
          _parsed = result;
          _isAnalyzing = false;
          _showConfirmation = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar: $e')),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // Confirmar y ejecutar escenario
  // ─────────────────────────────────────────────
  Future<void> _confirmParsed(NLTransaction tx) async {
    final amount = tx.amount ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se detectó un monto válido')),
      );
      return;
    }

    final accounts = ref.read(accountsStreamProvider).value ?? [];
    final defaultAccount = accounts.isNotEmpty
        ? accounts.firstWhere((a) => a.isDefault, orElse: () => accounts.first)
        : null;
    final accountId = tx.accountId ?? defaultAccount?.id;

    try {
      switch (tx.scenario) {
        case NLScenario.expense:
        case NLScenario.goalContribution:
        case NLScenario.wishlistPurchase:
          if (accountId == null) throw Exception('Sin cuenta');
          await ref.read(transactionServiceProvider).addTransaction(
            title: tx.title ?? 'Gasto',
            amount: amount,
            type: 'expense',
            categoryId: tx.categoryId ?? 'other_expense',
            accountId: accountId,
            note: tx.note ?? tx.rawInput,
          );
          if (tx.scenario == NLScenario.wishlistPurchase && tx.wishlistItemId != null) {
            ref.read(mockWishlistProvider.notifier).markAsPurchased(tx.wishlistItemId!);
          }
          break;

        case NLScenario.income:
          if (accountId == null) throw Exception('Sin cuenta');
          await ref.read(transactionServiceProvider).addTransaction(
            title: tx.title ?? 'Ingreso',
            amount: amount,
            type: 'income',
            categoryId: tx.categoryId ?? 'other_income',
            accountId: accountId,
            note: tx.note ?? tx.rawInput,
          );
          break;

        case NLScenario.cardPayment:
          final cardId = tx.cardId;
          final sourceId = tx.accountId;
          if (cardId == null || sourceId == null) {
            // No tenemos suficiente info, guardar como expense
            if (accountId != null) {
              await ref.read(transactionServiceProvider).addTransaction(
                title: tx.title ?? 'Pago tarjeta',
                amount: amount,
                type: 'expense',
                categoryId: 'cat_financial',
                accountId: accountId,
                note: tx.note ?? tx.rawInput,
              );
            }
          } else {
            await ref.read(accountServiceProvider).payCardStatement(
              sourceAccountId: sourceId,
              cardAccountId: cardId,
              amount: amount,
            );
          }
          break;

        case NLScenario.loanGiven:
          final pid = tx.personId;
          if (pid != null && accountId != null) {
            await ref.read(peopleServiceProvider).recordDirectDebt(
              personId: pid,
              amount: amount,
              iLent: true,
              description: tx.title ?? 'Préstamo',
              accountId: accountId,
            );
          } else if (accountId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Préstamo dado',
              amount: amount,
              type: 'expense',
              categoryId: 'cat_peer_to_peer',
              accountId: accountId,
              note: tx.note ?? tx.rawInput,
            );
          }
          break;

        case NLScenario.loanReceived:
          final pid = tx.personId;
          if (pid != null && accountId != null) {
            await ref.read(peopleServiceProvider).liquidateDebt(
              personId: pid,
              amount: amount,
              accountId: accountId,
            );
          } else if (accountId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Deuda recuperada',
              amount: amount,
              type: 'income',
              categoryId: 'cat_peer_to_peer',
              accountId: accountId,
              note: tx.note ?? tx.rawInput,
            );
          }
          break;

        case NLScenario.loanRepayment:
          // Yo le pagué a alguien lo que le debía (mi deuda con ellos baja)
          final pid = tx.personId;
          if (pid != null && accountId != null) {
            await ref.read(peopleServiceProvider).recordDirectDebt(
              personId: pid,
              amount: amount,
              iLent: false, // ellos me prestaron, yo devuelvo → saldo negativo → liquidar
              description: tx.title ?? 'Devolución de préstamo',
              accountId: accountId,
            );
          } else if (accountId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Devolución de préstamo',
              amount: amount,
              type: 'expense',
              categoryId: 'cat_peer_to_peer',
              accountId: accountId,
              note: tx.note ?? tx.rawInput,
            );
          }
          break;

        case NLScenario.sharedExpense:
          final pid = tx.personId;
          final ownAmt = tx.splitOwnAmount ?? amount / 2;
          final otherAmt = tx.splitOtherAmount ?? amount / 2;
          if (pid != null && accountId != null) {
            await ref.read(peopleServiceProvider).recordSharedExpense(
              personId: pid,
              totalAmount: amount,
              iPaid: true,
              ownAmount: ownAmt,
              otherAmount: otherAmt,
              description: tx.title ?? 'Gasto compartido',
              accountId: accountId,
            );
          } else if (accountId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Gasto compartido',
              amount: ownAmt,
              type: 'expense',
              categoryId: 'cat_peer_to_peer',
              accountId: accountId,
              note: tx.note ?? tx.rawInput,
            );
          }
          break;

        case NLScenario.internalTransfer:
          // Transferencia entre mis propias cuentas
          final srcId = tx.accountId;
          final tgtId = tx.targetAccountId;
          if (srcId != null && tgtId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Transferencia saliente',
              amount: amount,
              type: 'expense',
              categoryId: 'transfer',
              accountId: srcId,
              note: tx.rawInput,
            );
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Transferencia entrante',
              amount: amount,
              type: 'income',
              categoryId: 'transfer',
              accountId: tgtId,
              note: tx.rawInput,
            );
          } else if (srcId != null) {
            await ref.read(transactionServiceProvider).addTransaction(
              title: tx.title ?? 'Transferencia',
              amount: amount,
              type: 'expense',
              categoryId: 'transfer',
              accountId: srcId,
              note: tx.rawInput,
            );
          }
          break;

        case NLScenario.unclear:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo interpretar el movimiento. Usá el modo manual.')),
          );
          setState(() => _isSmart = false);
          return;
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tx.scenarioLabel} registrado: ${tx.title}'),
            backgroundColor: Colors.green.withValues(alpha: 0.8),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // ─────────────────────────────────────────────
  // Manual save
  // ─────────────────────────────────────────────
  void _saveManualTransaction() async {
    if (_amountController.text.isEmpty || _selectedAccount == null) return;
    final amount = double.tryParse(_amountController.text) ?? 0;
    final typeStr = _type == TransactionType.income ? 'income' : _type == TransactionType.transfer ? 'transfer' : 'expense';
    await ref.read(transactionServiceProvider).addTransaction(
      title: _titleController.text.isEmpty ? 'Movimiento' : _titleController.text,
      amount: amount,
      type: typeStr,
      categoryId: _selectedCategoryId,
      accountId: _selectedAccount!.id,
    );
    if (mounted) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accounts = ref.watch(accountsStreamProvider).value ?? [];
    if (_selectedAccount == null && accounts.isNotEmpty) {
      _selectedAccount = accounts.firstWhere((a) => a.isDefault, orElse: () => accounts.first);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 100),
      decoration: const BoxDecoration(
        color: Color(0xFF18181F),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text('Movimiento', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
                _SmartToggle(
                  isSmart: _isSmart,
                  onChanged: (val) => setState(() {
                    _isSmart = val;
                    _showConfirmation = false;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isSmart) _buildSmartUI(cs) else _buildManualUI(cs, accounts),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Smart UI (IA + Voz)
  // ─────────────────────────────────────────────
  Widget _buildSmartUI(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Escribí o dictá como hablás normalmente.',
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
        ),
        const SizedBox(height: 16),

        // Input area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isListening ? AppTheme.colorExpense : cs.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: _isListening
                    ? Row(
                        children: [
                          _PulsingDot(),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _aiController.text.isEmpty ? 'Escuchando...' : _aiController.text,
                              style: TextStyle(
                                color: _aiController.text.isEmpty ? AppTheme.colorTransfer : Colors.white,
                                fontStyle: _aiController.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      )
                    : TextField(
                        controller: _aiController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        maxLines: 3,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: 'Ej. Pagué 45 mil de sushi con Juan...',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _processAiInput(),
                      ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isListening ? AppTheme.colorExpense.withValues(alpha: 0.15) : AppTheme.colorTransfer.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: _isListening ? AppTheme.colorExpense : AppTheme.colorTransfer,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Ejemplos de uso
        if (!_showConfirmation && !_isAnalyzing) ...[
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _ExampleChip('Pagué 4500 de sushi', _aiController, () => setState(() {})),
              _ExampleChip('Cobré el sueldo 200k en MP', _aiController, () => setState(() {})),
              _ExampleChip('Presté 10k a Juan', _aiController, () => setState(() {})),
              _ExampleChip('Dividí el taxi con María, 3600 en total', _aiController, () => setState(() {})),
              _ExampleChip('Le devolví 5k a Pedro', _aiController, () => setState(() {})),
              _ExampleChip('Pasé 50k del Visa al MP', _aiController, () => setState(() {})),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Tarjeta de confirmación
        if (_showConfirmation && _parsed != null)
          _AiConfirmationCard(
            tx: _parsed!,
            accounts: ref.watch(accountsStreamProvider).value ?? [],
            people: ref.watch(peopleStreamProvider).value ?? [],
            onConfirm: _confirmParsed,
            onEdit: () => setState(() => _showConfirmation = false),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _processAiInput,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorTransfer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isAnalyzing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Analizando con IA...', style: TextStyle(fontSize: 15)),
                      ],
                    )
                  : const Text('Procesar Movimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Manual UI
  // ─────────────────────────────────────────────
  Widget _buildManualUI(ColorScheme cs, List<dom_acc.Account> accounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
          decoration: const InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(color: Colors.white10),
            prefixText: r'$ ',
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 8),
        _TypeSelector(current: _type, onChanged: (val) => setState(() => _type = val)),
        TextField(
          controller: _titleController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: const InputDecoration(
            hintText: '¿En qué se gastó?',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 16),
        if (accounts.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<dom_acc.Account>(
              value: _selectedAccount,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E2C),
              style: const TextStyle(color: Colors.white),
              underline: const SizedBox(),
              items: accounts.map((a) => DropdownMenuItem(
                value: a,
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 16, color: cs.primary),
                    const SizedBox(width: 8),
                    Text(a.name),
                  ],
                ),
              )).toList(),
              onChanged: (val) => setState(() => _selectedAccount = val),
            ),
          ),
        const SizedBox(height: 20),
        Text('Categoría', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12)),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: kCategoryEmojis.entries.map((entry) {
              final isSelected = _selectedCategoryId == entry.key;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategoryId = entry.key),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.colorTransfer.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? AppTheme.colorTransfer : Colors.transparent),
                        ),
                        alignment: Alignment.center,
                        child: Text(entry.value, style: const TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.key.split('_').first,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.white38, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _saveManualTransaction,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.colorTransfer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Guardar Movimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Tarjeta de confirmación de IA
// ─────────────────────────────────────────────────────────
class _AiConfirmationCard extends ConsumerStatefulWidget {
  final NLTransaction tx;
  final List<dom_acc.Account> accounts;
  final List<dom_p.Person> people;
  final void Function(NLTransaction) onConfirm;
  final VoidCallback onEdit;

  const _AiConfirmationCard({
    required this.tx,
    required this.accounts,
    required this.people,
    required this.onConfirm,
    required this.onEdit,
  });

  @override
  ConsumerState<_AiConfirmationCard> createState() => _AiConfirmationCardState();
}

class _AiConfirmationCardState extends ConsumerState<_AiConfirmationCard> {
  late NLTransaction _tx;
  late TextEditingController _amountCtrl;
  late TextEditingController _titleCtrl;
  dom_acc.Account? _selectedAccount;
  dom_acc.Account? _selectedTargetAccount;
  dom_p.Person? _selectedPerson;

  // Scenarios that involve a person
  static const _personScenarios = {
    NLScenario.loanGiven,
    NLScenario.loanReceived,
    NLScenario.loanRepayment,
    NLScenario.sharedExpense,
  };

  @override
  void initState() {
    super.initState();
    _tx = widget.tx;
    _amountCtrl = TextEditingController(text: _tx.amount?.toStringAsFixed(0) ?? '');
    _titleCtrl = TextEditingController(text: _tx.title ?? '');

    // Pre-select account from parsed result, or default
    if (widget.accounts.isNotEmpty) {
      final txAccId = _tx.accountId;
      _selectedAccount = txAccId != null
          ? widget.accounts.firstWhere((a) => a.id == txAccId, orElse: () => widget.accounts.first)
          : widget.accounts.firstWhere((a) => a.isDefault, orElse: () => widget.accounts.first);
    }

    // Pre-select target account for internalTransfer
    if (_tx.scenario == NLScenario.internalTransfer && _tx.targetAccountId != null && widget.accounts.isNotEmpty) {
      _selectedTargetAccount = widget.accounts.firstWhere(
        (a) => a.id == _tx.targetAccountId,
        orElse: () => widget.accounts.first,
      );
    }

    // Pre-select person from parsed result
    if (_tx.personId != null && widget.people.isNotEmpty) {
      try {
        _selectedPerson = widget.people.firstWhere((p) => p.id == _tx.personId);
      } catch (_) {}
    }
  }

  NLTransaction get _finalTx => _tx.copyWith(
        accountId: _selectedAccount?.id,
        targetAccountId: _selectedTargetAccount?.id,
        personId: _selectedPerson?.id,
      );

  @override
  void dispose() {
    _amountCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Color get _scenarioColor {
    switch (_tx.scenario) {
      case NLScenario.income:
      case NLScenario.loanReceived:
        return AppTheme.colorIncome;
      case NLScenario.cardPayment:
        return AppTheme.colorWarning;
      case NLScenario.loanGiven:
      case NLScenario.expense:
      case NLScenario.loanRepayment:
        return AppTheme.colorExpense;
      case NLScenario.goalContribution:
      case NLScenario.wishlistPurchase:
      case NLScenario.internalTransfer:
        return AppTheme.colorTransfer;
      case NLScenario.sharedExpense:
        return Colors.orange;
      default:
        return Colors.white54;
    }
  }

  IconData get _scenarioIcon {
    switch (_tx.scenario) {
      case NLScenario.income:
        return Icons.arrow_downward_rounded;
      case NLScenario.expense:
        return Icons.arrow_upward_rounded;
      case NLScenario.cardPayment:
        return Icons.credit_card_rounded;
      case NLScenario.loanGiven:
        return Icons.person_add_alt_1_rounded;
      case NLScenario.loanReceived:
        return Icons.person_remove_rounded;
      case NLScenario.loanRepayment:
        return Icons.reply_rounded;
      case NLScenario.sharedExpense:
        return Icons.group_rounded;
      case NLScenario.internalTransfer:
        return Icons.swap_horiz_rounded;
      case NLScenario.goalContribution:
        return Icons.flag_rounded;
      case NLScenario.wishlistPurchase:
        return Icons.shopping_cart_checkout_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String? _accountName(String? id) {
    if (id == null) return null;
    return widget.accounts.firstWhere((a) => a.id == id, orElse: () => widget.accounts.first).name;
  }

  @override
  Widget build(BuildContext context) {
    final color = _scenarioColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_scenarioIcon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IA detectó: ${_tx.scenarioLabel}',
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '"${_tx.rawInput}"',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Monto editable
          Row(
            children: [
              const Text(r'$ ', style: TextStyle(color: Colors.white54, fontSize: 18)),
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                  onChanged: (v) => _tx = _tx.copyWith(amount: double.tryParse(v)),
                ),
              ),
            ],
          ),

          // Título editable
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: 'Descripción...',
              hintStyle: TextStyle(color: Colors.white24),
            ),
            onChanged: (v) => _tx = _tx.copyWith(title: v),
          ),

          const SizedBox(height: 8),

          // Detalles detectados (categoría y tarjeta)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (_tx.categoryId != null)
                _InfoChip('${kCategoryEmojis[_tx.categoryId] ?? '📌'} ${_tx.categoryId!.split('_').first}', color),
              if (_accountName(_tx.cardId) != null)
                _InfoChip('💳 ${_accountName(_tx.cardId)}', Colors.white38),
            ],
          ),

          const SizedBox(height: 12),

          // Selector de cuenta (siempre visible, excepto cardPayment)
          if (_tx.scenario != NLScenario.cardPayment && widget.accounts.isNotEmpty) ...[
            Text(
              _tx.scenario == NLScenario.internalTransfer ? 'Cuenta origen:' : 'Cuenta:',
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 4),
            _AccountDropdown(
              accounts: widget.accounts,
              value: _selectedAccount,
              onChanged: (a) => setState(() => _selectedAccount = a),
            ),
            const SizedBox(height: 8),
          ],

          // Selector de cuenta destino (solo internalTransfer)
          if (_tx.scenario == NLScenario.internalTransfer && widget.accounts.isNotEmpty) ...[
            const Text('Cuenta destino:', style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 4),
            _AccountDropdown(
              accounts: widget.accounts.where((a) => a.id != _selectedAccount?.id).toList(),
              value: _selectedTargetAccount?.id == _selectedAccount?.id ? null : _selectedTargetAccount,
              onChanged: (a) => setState(() => _selectedTargetAccount = a),
            ),
            const SizedBox(height: 8),
          ],

          // Selector de persona (loanGiven, loanReceived, loanRepayment, sharedExpense)
          if (_personScenarios.contains(_tx.scenario) && widget.people.isNotEmpty) ...[
            const Text('Persona:', style: TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<dom_p.Person>(
                value: _selectedPerson,
                isExpanded: true,
                dropdownColor: const Color(0xFF1E1E2C),
                underline: const SizedBox(),
                hint: const Text('Seleccioná una persona', style: TextStyle(color: Colors.white38, fontSize: 13)),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                items: widget.people.map((p) => DropdownMenuItem(
                  value: p,
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, size: 14, color: Colors.white38),
                      const SizedBox(width: 6),
                      Text(p.displayName),
                    ],
                  ),
                )).toList(),
                onChanged: (p) => setState(() => _selectedPerson = p),
              ),
            ),
            // Balance info si hay persona seleccionada
            if (_selectedPerson != null) ...[
              const SizedBox(height: 6),
              _PersonBalanceChip(_selectedPerson!, _tx, color),
            ],
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 8),

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white54,
                    side: const BorderSide(color: Colors.white12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Editar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () => widget.onConfirm(_finalTx.copyWith(
                    amount: double.tryParse(_amountCtrl.text) ?? _tx.amount,
                    title: _titleCtrl.text.isNotEmpty ? _titleCtrl.text : _tx.title,
                  )),
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirmar →', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Widgets auxiliares
// ─────────────────────────────────────────────────────────

class _AccountDropdown extends StatelessWidget {
  final List<dom_acc.Account> accounts;
  final dom_acc.Account? value;
  final ValueChanged<dom_acc.Account?> onChanged;

  const _AccountDropdown({required this.accounts, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final effective = (value != null && accounts.any((a) => a.id == value!.id)) ? value : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<dom_acc.Account>(
        value: effective,
        isExpanded: true,
        dropdownColor: const Color(0xFF1E1E2C),
        underline: const SizedBox(),
        hint: const Text('Seleccioná cuenta', style: TextStyle(color: Colors.white38, fontSize: 13)),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        items: accounts.map((a) => DropdownMenuItem(
          value: a,
          child: Row(
            children: [
              Icon(
                a.isCreditCard ? Icons.credit_card_rounded : Icons.account_balance_wallet_outlined,
                size: 14,
                color: Colors.white38,
              ),
              const SizedBox(width: 6),
              Text(a.name),
            ],
          ),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _PersonBalanceChip extends StatelessWidget {
  final dom_p.Person person;
  final NLTransaction tx;
  final Color color;

  const _PersonBalanceChip(this.person, this.tx, this.color);

  @override
  Widget build(BuildContext context) {
    final balance = person.totalBalance;
    final amount = tx.amount ?? 0;
    double projected = balance;

    switch (tx.scenario) {
      case NLScenario.loanGiven:
        projected = balance + amount;
        break;
      case NLScenario.loanReceived:
      case NLScenario.loanRepayment:
        projected = balance - amount;
        break;
      case NLScenario.sharedExpense:
        projected = balance + (tx.splitOtherAmount ?? amount / 2);
        break;
      default:
        break;
    }

    final balanceColor = balance > 0 ? Colors.green : balance < 0 ? Colors.redAccent : Colors.white38;
    final projectedColor = projected > 0 ? Colors.green : projected < 0 ? Colors.redAccent : Colors.white38;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${person.displayName}: ', style: const TextStyle(color: Colors.white54, fontSize: 11)),
          Text(
            '\$${balance.abs().toStringAsFixed(0)} ${balance >= 0 ? 'te debe' : 'le debés'}',
            style: TextStyle(color: balanceColor, fontSize: 11, fontWeight: FontWeight.w600),
          ),
          if (projected != balance) ...[
            const Text(' → ', style: TextStyle(color: Colors.white24, fontSize: 11)),
            Text(
              '\$${projected.abs().toStringAsFixed(0)} ${projected >= 0 ? 'te debe' : 'le debés'}',
              style: TextStyle(color: projectedColor, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final VoidCallback onTap;
  const _ExampleChip(this.text, this.controller, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.text = text;
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(color: AppTheme.colorExpense, shape: BoxShape.circle),
      ),
    );
  }
}

class _SmartToggle extends StatelessWidget {
  final bool isSmart;
  final ValueChanged<bool> onChanged;
  const _SmartToggle({required this.isSmart, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSmart ? Icons.auto_awesome_rounded : Icons.edit_note_rounded,
            size: 14,
            color: isSmart ? AppTheme.colorTransfer : Colors.white54,
          ),
          const SizedBox(width: 4),
          Text(
            isSmart ? 'IA' : 'Manual',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: isSmart,
              activeTrackColor: AppTheme.colorTransfer.withValues(alpha: 0.3),
              activeThumbColor: AppTheme.colorTransfer,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final TransactionType current;
  final ValueChanged<TransactionType> onChanged;
  const _TypeSelector({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _TypeButton(isSelected: current == TransactionType.expense, label: 'Gasto', onTap: () => onChanged(TransactionType.expense)),
          _TypeButton(isSelected: current == TransactionType.income, label: 'Ingreso', onTap: () => onChanged(TransactionType.income)),
          _TypeButton(isSelected: current == TransactionType.transfer, label: 'Transfer', onTap: () => onChanged(TransactionType.transfer)),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  const _TypeButton({required this.isSelected, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.colorTransfer : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
