import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/logic/goal_service.dart';
import '../../domain/models/goal.dart';
import '../providers/goals_provider.dart';
import '../widgets/add_goal_bottom_sheet.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _deleteGoal(Goal goal) async {
    await ref.read(goalServiceProvider).deleteGoal(goal.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${goal.name}" eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final activeGoals = ref.watch(activeGoalsProvider);
    final completedGoals = ref.watch(completedGoalsProvider);
    final isEmpty = activeGoals.isEmpty && completedGoals.isEmpty;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Text(
                  'Objetivos',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            if (isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyGoals(
                  onAdd: () => AddGoalBottomSheet.show(context),
                ),
              ),

            if (activeGoals.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: Text(
                    'En progreso',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: activeGoals.length,
                  itemBuilder: (context, index) {
                    return _GoalCard(
                      goal: activeGoals[index],
                      onDelete: () => _deleteGoal(activeGoals[index]),
                    );
                  },
                ),
              ),
            ],

            if (completedGoals.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, 12),
                  child: Text(
                    'Completados',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: completedGoals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _CompletedGoalCard(
                      goal: completedGoals[index],
                      onDelete: () => _deleteGoal(completedGoals[index]),
                    );
                  },
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────
class _EmptyGoals extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyGoals({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 64,
                color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text('Sin objetivos',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              'Creá una meta de ahorro para seguir tu progreso.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Crear objetivo'),
              style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.colorTransfer,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Goal Card (Grid Item)
// ──────────────────────────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const _GoalCard({required this.goal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(
        symbol: '\$', decimalDigits: 0, locale: 'es_AR');
    final cs = Theme.of(context).colorScheme;

    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.03), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: goal.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(goal.icon, color: goal.color, size: 20),
              ),
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: goal.progress,
                      strokeWidth: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(goal.color),
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Text(
                        '${(goal.progress * 100).toInt()}%',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            goal.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
                letterSpacing: -0.2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${fmt.format(goal.savedAmount)} / ${fmt.format(goal.targetAmount)}',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: goal.color),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Faltan ${fmt.format(goal.remaining)}',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurfaceVariant),
                    ),
                    if (goal.deadline != null) ...[
                      const SizedBox(height: 2),
                      _DeadlineLabel(deadline: goal.deadline!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx) => _buildOptionsSheet(ctx),
        );
      },
      child: card,
    );
  }

  Widget _buildOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF18181F),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Gestión de Objetivo',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(goal.name,
              style: const TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 24),
          ListTile(
            leading: Icon(Icons.edit_rounded, color: AppTheme.colorTransfer),
            title: const Text('Editar Objetivo',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              AddGoalBottomSheet.show(context, goalToEdit: goal);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_rounded,
                color: AppTheme.colorExpense),
            title: Text('Eliminar Objetivo',
                style: TextStyle(
                    color: AppTheme.colorExpense,
                    fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Completed Goal Card (List Item)
// ──────────────────────────────────────────────────────────────────
class _CompletedGoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onDelete;

  const _CompletedGoalCard({required this.goal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(
        symbol: '\$', decimalDigits: 0, locale: 'es_AR');
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF18181F),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Icon(Icons.delete_forever_rounded,
                      color: AppTheme.colorExpense),
                  title: Text('Eliminar "${goal.name}"',
                      style: TextStyle(
                          color: AppTheme.colorExpense,
                          fontWeight: FontWeight.w500)),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDelete();
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.03), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.greenAccent, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.white,
                        letterSpacing: -0.2,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.white54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Completado por ${fmt.format(goal.targetAmount)}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Deadline Label
// ──────────────────────────────────────────────────────────────────
class _DeadlineLabel extends StatelessWidget {
  final DateTime deadline;
  const _DeadlineLabel({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    final days = diff.inDays;

    String text;
    Color color;

    if (days < 0) {
      text = 'Venció hace ${(-days)} días';
      color = AppTheme.colorExpense;
    } else if (days == 0) {
      text = '¡Hoy es el día!';
      color = AppTheme.colorWarning;
    } else if (days <= 7) {
      text = 'Quedan $days días';
      color = AppTheme.colorWarning;
    } else if (days <= 30) {
      text = 'Quedan $days días';
      color = AppTheme.colorTransfer;
    } else {
      final months = (days / 30).floor();
      final remDays = days - months * 30;
      text = months == 1
          ? '1 mes${remDays > 0 ? ' y $remDays días' : ''}'
          : '$months meses${remDays > 0 ? ' y $remDays días' : ''}';
      color = AppTheme.colorTransfer;
    }

    return Row(
      children: [
        Icon(Icons.schedule_rounded, size: 10, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ],
    );
  }
}
