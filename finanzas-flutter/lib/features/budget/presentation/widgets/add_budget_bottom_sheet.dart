import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/logic/budget_service.dart';
import '../../domain/models/budget.dart';

class AddBudgetBottomSheet extends ConsumerStatefulWidget {
  final Budget? budgetToEdit;

  const AddBudgetBottomSheet({super.key, this.budgetToEdit});

  static Future<void> show(BuildContext context, {Budget? budgetToEdit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBudgetBottomSheet(budgetToEdit: budgetToEdit),
    );
  }

  @override
  ConsumerState<AddBudgetBottomSheet> createState() =>
      _AddBudgetBottomSheetState();
}

class _AddBudgetBottomSheetState extends ConsumerState<AddBudgetBottomSheet> {
  late final TextEditingController _categoryController;
  late final TextEditingController _limitController;
  bool _isFixed = false;
  String _selectedIconKey = 'pie_chart';
  Color _selectedColor = AppTheme.colorTransfer;
  bool _saving = false;

  static const List<String> _iconKeys = [
    'pie_chart', 'shopping_cart', 'restaurant', 'car', 'home',
    'tv', 'fitness', 'health', 'education', 'phone',
  ];

  final List<Color> _availableColors = [
    AppTheme.colorTransfer,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.amberAccent,
  ];

  @override
  void initState() {
    super.initState();
    final b = widget.budgetToEdit;
    _categoryController = TextEditingController(text: b?.categoryName ?? '');
    _limitController = TextEditingController(
        text: b != null ? b.limitAmount.toInt().toString() : '');
    _isFixed = b?.isFixed ?? false;
    _selectedIconKey = b?.iconKey ?? 'pie_chart';
    _selectedColor =
        b != null ? Color(b.colorValue) : AppTheme.colorTransfer;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _categoryController.text.trim();
    final amountText = _limitController.text.trim();
    if (name.isEmpty || amountText.isEmpty) return;
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    setState(() => _saving = true);
    final service = ref.read(budgetServiceProvider);
    final isEditing = widget.budgetToEdit != null;

    try {
      if (isEditing) {
        await service.updateBudget(
          widget.budgetToEdit!.id,
          widget.budgetToEdit!.categoryId,
          categoryName: name,
          limitAmount: amount,
          isFixed: _isFixed,
          colorValue: _selectedColor.toARGB32(),
          iconKey: _selectedIconKey,
        );
      } else {
        await service.addBudget(
          categoryName: name,
          limitAmount: amount,
          isFixed: _isFixed,
          colorValue: _selectedColor.toARGB32(),
          iconKey: _selectedIconKey,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.budgetToEdit != null;
    final currentIcon =
        Budget.iconMap[_selectedIconKey] ?? Icons.pie_chart_rounded;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF18181F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(currentIcon, color: _selectedColor),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditing ? 'Editar Presupuesto' : 'Añadir Presupuesto',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Íconos
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _iconKeys.length,
                  itemBuilder: (context, index) {
                    final key = _iconKeys[index];
                    final iconData = Budget.iconMap[key]!;
                    final isSelected = key == _selectedIconKey;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIconKey = key),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withValues(alpha: 0.2)
                              : Colors.white.withAlpha(10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? _selectedColor
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(
                          iconData,
                          color: isSelected ? _selectedColor : Colors.white38,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Colores
              SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableColors.length,
                  itemBuilder: (context, index) {
                    final color = _availableColors[index];
                    final isSelected =
                        color.toARGB32() == _selectedColor.toARGB32();
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              TextField(
                controller: _categoryController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ej. Supermercado',
                  labelText: 'Categoría',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  labelText: 'Monto Límite',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(
                  'Gasto Fijo / Suscripción',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Ej. Alquiler, Netflix, Internet',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                value: _isFixed,
                onChanged: (val) => setState(() => _isFixed = val),
                activeThumbColor: AppTheme.colorTransfer,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _saving ? null : _submit,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(isEditing
                          ? 'Guardar Cambios'
                          : 'Crear Presupuesto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
