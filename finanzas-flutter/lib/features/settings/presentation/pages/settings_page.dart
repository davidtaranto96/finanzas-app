import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../../core/database/database_seeder.dart';
import '../../../../core/database/database_providers.dart' hide databaseProvider;
import '../../../../core/logic/ai_transaction_parser.dart';
import '../../../../core/logic/user_profile_service.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final db = ref.read(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configuración',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _SectionTitle('Mi Perfil'),
          _ProfileTile(),

          const SizedBox(height: 24),
          _SectionTitle('General'),
          _SettingsListTile(
            icon: Icons.dark_mode_rounded,
            title: 'Apariencia',
            subtitle: 'Tema Oscuro',
            onTap: () {},
          ),
          _SettingsListTile(
            icon: Icons.attach_money_rounded,
            title: 'Moneda Principal',
            subtitle: 'Peso Argentino (ARS)',
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _SectionTitle('Preferencias de Finanzas'),
          _SettingsListTile(
            icon: Icons.category_rounded,
            title: 'Administrar Categorías',
            subtitle: 'Personalizá tus agrupaciones de gasto',
            onTap: () {},
          ),
          _SettingsListTile(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Administrar Cuentas',
            subtitle: 'Efectivo, Bancos, Tarjetas',
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _SectionTitle('Inteligencia Artificial'),
          _ApiKeyTile(),

          const SizedBox(height: 24),
          _SectionTitle('Datos y Backup'),
          _SettingsListTile(
            icon: Icons.cloud_upload_rounded,
            title: 'Exportar Datos',
            subtitle: 'Generar CSV de todos los movimientos',
            onTap: () {},
          ),
          
          const SizedBox(height: 32),
          _SectionTitle('Zona de Peligro', color: cs.error),
          Container(
            decoration: BoxDecoration(
              color: cs.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.error.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Icon(Icons.bug_report_rounded, color: AppTheme.colorWarning),
                  title: const Text('Cargar datos de prueba', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Genera movimientos falsos en SQLite para probar', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  onTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generando datos en Drift...')),
                    );
                    final seeder = DatabaseSeeder(db);
                    await seeder.clearAndSeedMockData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos generados con éxito. Usa Refrescar.')),
                      );
                    }
                  },
                ),
                Divider(color: cs.error.withValues(alpha: 0.2), height: 1),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Icon(Icons.delete_forever_rounded, color: cs.error),
                  title: Text('Borrar todos los datos', style: TextStyle(color: cs.error, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Elimina cuentas, movimientos, objetivos y presupuestos', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E2C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('¿Borrar todo?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        content: const Text(
                          'Se eliminarán todas las cuentas, movimientos, objetivos, presupuestos y personas. Esta acción no se puede deshacer.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: FilledButton.styleFrom(backgroundColor: cs.error),
                            child: const Text('Borrar todo'),
                          ),
                        ],
                      ),
                    );
                    if (confirm != true) return;
                    if (!context.mounted) return;
                    await db.delete(db.transactionsTable).go();
                    await db.delete(db.accountsTable).go();
                    await db.delete(db.categoriesTable).go();
                    await db.delete(db.personsTable).go();
                    await db.delete(db.goalsTable).go();
                    await db.delete(db.budgetsTable).go();
                    await db.delete(db.groupsTable).go();
                    await db.delete(db.userProfileTable).go();
                    await db.ensureDefaultCashAccount();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Todos los datos fueron eliminados.')),
                      );
                      context.go('/home');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// API Key tile (con StatefulWidget para manejo de estado local)
// ─────────────────────────────────────────────────────────
class _ApiKeyTile extends StatefulWidget {
  @override
  State<_ApiKeyTile> createState() => _ApiKeyTileState();
}

class _ApiKeyTileState extends State<_ApiKeyTile> {
  String? _apiKey;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final key = await AiTransactionParser.getApiKey();
    if (mounted) setState(() { _apiKey = key; _loading = false; });
  }

  bool get _hasKey => _apiKey != null && _apiKey!.isNotEmpty;

  void _showKeyDialog() {
    final ctrl = TextEditingController(text: _apiKey ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('API Key de Anthropic', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Necesitás una API key de Anthropic para usar la detección inteligente de movimientos con IA.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'sk-ant-...',
                labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          if (_hasKey)
            TextButton(
              onPressed: () async {
                await AiTransactionParser.clearApiKey();
                if (mounted) setState(() => _apiKey = null);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Eliminar', style: TextStyle(color: AppTheme.colorExpense)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
          ),
          FilledButton(
            onPressed: () async {
              final key = ctrl.text.trim();
              if (key.isNotEmpty) {
                await AiTransactionParser.saveApiKey(key);
                if (mounted) setState(() => _apiKey = key);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.colorTransfer),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _hasKey
            ? AppTheme.colorIncome.withValues(alpha: 0.08)
            : const Color(0xFF1E1E2C).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _hasKey
              ? AppTheme.colorIncome.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ListTile(
        onTap: _showKeyDialog,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (_hasKey ? AppTheme.colorIncome : AppTheme.colorTransfer).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: _hasKey ? AppTheme.colorIncome : AppTheme.colorTransfer,
            size: 22,
          ),
        ),
        title: const Text('IA — API Key de Anthropic', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        subtitle: Text(
          _hasKey ? 'Configurada ✓ — Tocá para cambiar o eliminar' : 'Sin configurar — La IA usará modo regex como fallback',
          style: TextStyle(
            fontSize: 12,
            color: _hasKey ? AppTheme.colorIncome : Colors.white38,
          ),
        ),
        trailing: Icon(
          _hasKey ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
          color: _hasKey ? AppTheme.colorIncome : Colors.white38,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color? color;

  const _SectionTitle(this.title, {this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color ?? Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Profile Tile
// ─────────────────────────────────────────────────────────
class _ProfileTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final profile = profileAsync.valueOrNull;
    final fmt = NumberFormat.currency(symbol: '\$', decimalDigits: 0, locale: 'es_AR');

    final hasData = profile != null && (profile.monthlySalary != null || profile.payDay != null);
    final subtitle = hasData
        ? [
            if (profile.monthlySalary != null) 'Sueldo: ${fmt.format(profile.monthlySalary)}',
            if (profile.payDay != null) 'Día de cobro: ${profile.payDay}',
          ].join(' · ')
        : 'Configurá tu sueldo y día de cobro';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: hasData
            ? AppTheme.colorTransfer.withValues(alpha: 0.08)
            : const Color(0xFF1E1E2C).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasData
              ? AppTheme.colorTransfer.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: ListTile(
        onTap: () => _showProfileEditor(context, ref, profile),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.colorTransfer.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.person_rounded, color: AppTheme.colorTransfer, size: 22),
        ),
        title: Text(
          profile?.name?.isNotEmpty == true ? profile!.name! : 'Mi Perfil',
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: hasData ? AppTheme.colorTransfer : Colors.white54,
          ),
        ),
        trailing: Icon(
          hasData ? Icons.edit_rounded : Icons.chevron_right_rounded,
          color: hasData ? AppTheme.colorTransfer : Colors.white38,
          size: 20,
        ),
      ),
    );
  }

  void _showProfileEditor(BuildContext context, WidgetRef ref, dynamic profile) {
    final nameCtrl = TextEditingController(text: profile?.name ?? '');
    final salaryCtrl = TextEditingController(
      text: profile?.monthlySalary != null ? profile.monthlySalary.toStringAsFixed(0) : '',
    );
    final payDayCtrl = TextEditingController(
      text: profile?.payDay != null ? profile.payDay.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          decoration: const BoxDecoration(
            color: Color(0xFF18181F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Mi Perfil',
                style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Estos datos se usan para la cuenta regresiva de cobro y el registro automático del ingreso.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Tu nombre (opcional)',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Colors.white38),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: salaryCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Sueldo mensual',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  prefixText: r'$ ',
                  prefixIcon: const Icon(Icons.payments_outlined, color: Colors.white38),
                  hintText: 'Ej: 850000',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: payDayCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Día de cobro (1-31)',
                  labelStyle: const TextStyle(color: AppTheme.colorTransfer),
                  prefixIcon: const Icon(Icons.calendar_today_rounded, color: Colors.white38),
                  hintText: 'Ej: 5',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () async {
                    final payDay = int.tryParse(payDayCtrl.text);
                    if (payDay != null && (payDay < 1 || payDay > 31)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El día de cobro debe ser entre 1 y 31')),
                      );
                      return;
                    }
                    await ref.read(userProfileServiceProvider).updateProfile(
                      name: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
                      monthlySalary: double.tryParse(salaryCtrl.text),
                      payDay: payDay,
                      clearSalary: salaryCtrl.text.trim().isEmpty,
                      clearPayDay: payDayCtrl.text.trim().isEmpty,
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perfil actualizado')),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.colorTransfer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white38),
      ),
    );
  }
}
