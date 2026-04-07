import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/home_widgets_provider.dart';

void showHomeWidgetConfigSheet(BuildContext context, WidgetRef ref) {
  final config = ref.read(homeWidgetConfigProvider);
  // Split into active (top) and hidden (bottom)
  final activeOrder = <String>[];
  final hiddenOrder = <String>[];
  for (final id in config.order) {
    if (config.hidden.contains(id)) {
      hiddenOrder.add(id);
    } else {
      activeOrder.add(id);
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF18181F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Personalizar inicio',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        // Merge active + hidden back into a single order
                        final mergedOrder = [...activeOrder, ...hiddenOrder];
                        final mergedHidden = hiddenOrder.toSet();

                        final notifier = ref.read(homeWidgetConfigProvider.notifier);
                        notifier.setOrder(mergedOrder);
                        // Sync hidden state
                        final currentHidden = ref.read(homeWidgetConfigProvider).hidden;
                        for (final id in kHomeWidgets.keys) {
                          final shouldHide = mergedHidden.contains(id);
                          final isHidden = currentHidden.contains(id);
                          if (shouldHide != isHidden) {
                            notifier.toggleVisibility(id);
                          }
                        }
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorTransfer,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Guardar', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Arrastrá para reordenar · Tocá el ojo para mostrar/ocultar',
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white38),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // ── Active widgets (reorderable) ──
                    _buildReorderableSection(
                      items: activeOrder,
                      isHiddenSection: false,
                      onReorder: (oldIndex, newIndex) {
                        setLocal(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = activeOrder.removeAt(oldIndex);
                          activeOrder.insert(newIndex, item);
                        });
                      },
                      onToggle: (widgetId) {
                        setLocal(() {
                          activeOrder.remove(widgetId);
                          hiddenOrder.add(widgetId);
                        });
                      },
                    ),
                    // ── Divider ──
                    if (hiddenOrder.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Ocultos',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white24,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      // ── Hidden widgets ──
                      ...hiddenOrder.map((widgetId) {
                        final info = kHomeWidgets[widgetId];
                        if (info == null) return const SizedBox.shrink();
                        return _WidgetTile(
                          key: ValueKey('hidden_$widgetId'),
                          widgetId: widgetId,
                          info: info,
                          isHidden: true,
                          isLocked: false,
                          showDragHandle: false,
                          onToggle: () {
                            setLocal(() {
                              hiddenOrder.remove(widgetId);
                              activeOrder.add(widgetId);
                            });
                          },
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildReorderableSection({
  required List<String> items,
  required bool isHiddenSection,
  required void Function(int, int) onReorder,
  required void Function(String) onToggle,
}) {
  return ReorderableListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    onReorder: onReorder,
    proxyDecorator: (child, index, animation) => Material(
      color: Colors.transparent,
      elevation: 4,
      shadowColor: AppTheme.colorTransfer.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(14),
      child: child,
    ),
    itemBuilder: (ctx, index) {
      final widgetId = items[index];
      final info = kHomeWidgets[widgetId];
      if (info == null) return const SizedBox.shrink(key: ValueKey('empty'));
      final isLocked = kAlwaysVisibleWidgets.contains(widgetId);

      return _WidgetTile(
        key: ValueKey(widgetId),
        widgetId: widgetId,
        info: info,
        isHidden: false,
        isLocked: isLocked,
        showDragHandle: true,
        onToggle: isLocked ? null : () => onToggle(widgetId),
      );
    },
  );
}

class _WidgetTile extends StatelessWidget {
  final String widgetId;
  final ({IconData icon, String label}) info;
  final bool isHidden;
  final bool isLocked;
  final bool showDragHandle;
  final VoidCallback? onToggle;

  const _WidgetTile({
    super.key,
    required this.widgetId,
    required this.info,
    required this.isHidden,
    required this.isLocked,
    required this.showDragHandle,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHidden
            ? Colors.white.withValues(alpha: 0.02)
            : const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHidden
              ? Colors.white.withValues(alpha: 0.05)
              : AppTheme.colorTransfer.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          if (showDragHandle)
            const Icon(Icons.drag_handle_rounded,
                size: 20, color: Colors.white38)
          else
            const SizedBox(width: 20),
          const SizedBox(width: 12),
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: (isHidden
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppTheme.colorTransfer.withValues(alpha: 0.12)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(info.icon,
              size: 16,
              color: isHidden ? Colors.white24 : AppTheme.colorTransfer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(info.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isHidden ? Colors.white38 : Colors.white,
              ),
            ),
          ),
          if (isLocked)
            Icon(Icons.lock_rounded,
                size: 14,
                color: Colors.white.withValues(alpha: 0.15))
          else
            GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isHidden
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: 20,
                  color: isHidden
                      ? Colors.white24
                      : AppTheme.colorIncome.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
