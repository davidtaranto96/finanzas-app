import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../providers/tab_config_provider.dart';

void showTabConfigSheet(BuildContext context, WidgetRef ref) {
  final currentTabs = List<String>.from(ref.read(tabConfigProvider));

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) {
        final allDisabled =
            kAllTabs.where((t) => !currentTabs.contains(t)).toList();

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.82,
          ),
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF18181F),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(32)),
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
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Personalizar navegación',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(tabConfigProvider.notifier)
                            .setOrder(currentTabs);
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.colorTransfer,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: const Text('Guardar',
                          style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                    'Mantené presionado y arrastrá para reordenar · Máximo $kMaxVisibleTabs',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: Colors.white38)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ACTIVAS  (${currentTabs.length})',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white38,
                          letterSpacing: 1)),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: currentTabs.length,
                      onReorder: (oldIndex, newIndex) {
                        setLocal(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = currentTabs.removeAt(oldIndex);
                          currentTabs.insert(newIndex, item);
                        });
                      },
                      proxyDecorator: (child, index, animation) =>
                          Material(
                        color: Colors.transparent,
                        elevation: 4,
                        shadowColor: AppTheme.colorTransfer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        child: child,
                      ),
                      itemBuilder: (ctx, index) {
                        final tabId = currentTabs[index];
                        final info = kTabInfo[tabId]!;
                        final locked =
                            kAlwaysVisibleTabs.contains(tabId);
                        return Container(
                          key: ValueKey(tabId),
                          margin:
                              const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2C),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: AppTheme.colorTransfer
                                    .withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.drag_handle_rounded,
                                  size: 20, color: Colors.white38),
                              const SizedBox(width: 12),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.colorTransfer
                                      .withValues(alpha: 0.12),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: Icon(info.icon,
                                    size: 16,
                                    color: AppTheme.colorTransfer),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(info.label,
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),
                              if (locked)
                                Icon(Icons.lock_rounded,
                                    size: 14,
                                    color: Colors.white
                                        .withValues(alpha: 0.15))
                              else
                                GestureDetector(
                                  onTap: () {
                                    if (currentTabs.length <= 3) return;
                                    setLocal(() {
                                      currentTabs.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                      Icons
                                          .remove_circle_outline_rounded,
                                      size: 20,
                                      color: currentTabs.length <= 3
                                          ? Colors.white12
                                          : AppTheme.colorExpense
                                              .withValues(alpha: 0.7)),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (allDisabled.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'DISPONIBLES  (${allDisabled.length})',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white38,
                                  letterSpacing: 1)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...allDisabled.map((tabId) {
                        final info = kTabInfo[tabId]!;
                        final canAdd =
                            currentTabs.length < kMaxVisibleTabs;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.03),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 32),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withValues(alpha: 0.05),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Icon(info.icon,
                                      size: 16,
                                      color: Colors.white38),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(info.label,
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white54)),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!canAdd) return;
                                    setLocal(() {
                                      final moreIdx = currentTabs
                                          .indexOf('more');
                                      if (moreIdx >= 0 &&
                                          moreIdx ==
                                              currentTabs.length - 1) {
                                        currentTabs.insert(
                                            moreIdx, tabId);
                                      } else {
                                        currentTabs.add(tabId);
                                      }
                                    });
                                  },
                                  child: Icon(
                                      Icons
                                          .add_circle_outline_rounded,
                                      size: 20,
                                      color: canAdd
                                          ? AppTheme.colorIncome
                                              .withValues(alpha: 0.7)
                                          : Colors.white12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 16),
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
