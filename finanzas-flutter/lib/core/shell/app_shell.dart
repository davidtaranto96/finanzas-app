import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/database/database_providers.dart';
import '../../core/providers/shell_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/budget/presentation/widgets/add_budget_bottom_sheet.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/goals/presentation/widgets/add_goal_bottom_sheet.dart';
import '../../features/more/presentation/pages/more_page.dart';

class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  static const tabs = [
    _TabItem(path: '/home', label: 'Home', icon: Icons.home_rounded),
    _TabItem(path: '/transactions', label: 'Movimientos', icon: Icons.swap_horiz_rounded),
    _TabItem(path: '/budget', label: 'Presupuesto', icon: Icons.donut_large_rounded),
    _TabItem(path: '/goals', label: 'Objetivos', icon: Icons.flag_rounded),
    _TabItem(path: '/more', label: 'Más', icon: Icons.grid_view_rounded),
  ];

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.navigationShell.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AppShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) {
      _pageController.jumpToPage(widget.navigationShell.currentIndex);
    }
  }

  void _onPageChanged(int index) {
    if (ref.read(txSearchActiveProvider)) {
      ref.read(txSearchActiveProvider.notifier).state = false;
      ref.read(txSearchQueryProvider.notifier).state = '';
      _searchController.clear();
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _onTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // nav bar: height 70 + bottomPadding+12 from screen bottom
    // nav bar TOP = bottomPadding + 82
    // FAB bottom = bottomPadding + 90 (8px gap above nav bar)
    final fabBottom = bottomPadding + 90.0;

    final budgets = ref.watch(budgetsStreamProvider).valueOrNull ?? [];
    final goals = ref.watch(goalsStreamProvider).valueOrNull ?? [];
    final txSearchActive = ref.watch(txSearchActiveProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: const [
              HomePage(),
              TransactionsPage(),
              BudgetPage(),
              GoalsPage(),
              MorePage(),
            ],
          ),

          // Tab 1 - Movimientos: search
          if (currentIndex == 1)
            Positioned(
              right: txSearchActive ? 0 : 16,
              left: txSearchActive ? 0 : null,
              bottom: fabBottom,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: txSearchActive
                    ? Center(
                        key: const ValueKey('search_bar'),
                        child: _SearchBar(
                          controller: _searchController,
                          onClose: () {
                            ref.read(txSearchActiveProvider.notifier).state = false;
                            ref.read(txSearchQueryProvider.notifier).state = '';
                            _searchController.clear();
                          },
                          onChanged: (v) =>
                              ref.read(txSearchQueryProvider.notifier).state = v,
                        ),
                      )
                    : _AppFab(
                        key: const ValueKey('search_fab'),
                        icon: Icons.search_rounded,
                        onPressed: () =>
                            ref.read(txSearchActiveProvider.notifier).state = true,
                      ),
              ),
            ),

          // Tab 2 - Presupuesto
          if (currentIndex == 2 && budgets.isNotEmpty)
            Positioned(
              right: 16,
              bottom: fabBottom,
              child: _AppFab(
                icon: Icons.add_rounded,
                onPressed: () => AddBudgetBottomSheet.show(context),
              ),
            ),

          // Tab 3 - Objetivos
          if (currentIndex == 3 && goals.isNotEmpty)
            Positioned(
              right: 16,
              bottom: fabBottom,
              child: _AppFab(
                icon: Icons.add_rounded,
                onPressed: () => AddGoalBottomSheet.show(context),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: bottomPadding + 12),
        child: _FloatingNavBar(
          currentIndex: currentIndex,
          tabs: AppShell.tabs,
          onTap: _onTap,
        ),
      ),
    );
  }
}

class _AppFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _AppFab({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: onPressed,
      backgroundColor: AppTheme.colorTransfer,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Icon(icon, size: 28),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClose;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onClose, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2C).withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(27),
              border: Border.all(color: AppTheme.colorTransfer.withValues(alpha: 0.30)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.search_rounded, size: 18,
                    color: AppTheme.colorTransfer.withValues(alpha: 0.8)),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    onChanged: onChanged,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar movimientos...',
                      hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.white38),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 44, height: 54,
                    alignment: Alignment.center,
                    child: const Icon(Icons.close_rounded, size: 18, color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;
  const _FloatingNavBar({required this.currentIndex, required this.tabs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFF18181F).withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07), width: 0.8),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: tabs.asMap().entries.map((e) => Expanded(
              child: _NavItem(tab: e.value, selected: e.key == currentIndex, onTap: () => onTap(e.key)),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final _TabItem tab;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.tab, required this.selected, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) { _controller.reverse(); widget.onTap(); }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _scale,
              builder: (context, child) => Transform.scale(
                scale: _scale.value,
                child: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12 * _scale.value),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(widget.tab.icon,
                    key: ValueKey(isSelected),
                    size: isSelected ? 23 : 22,
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.38),
                  ),
                ),
                const SizedBox(height: 4),
                Text(widget.tab.label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.38),
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

class _TabItem {
  final String path;
  final String label;
  final IconData icon;
  const _TabItem({required this.path, required this.label, required this.icon});
}
