import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/parsed_transaction.dart';

/// Motor de ingesta de resúmenes de tarjeta de crédito ICBC (Visa y Mastercard).
///
/// Soporta:
///  - Mastercard ICBC: "DD-Mon-YY DESCRIPCION [CC/TT] NNNNN MONTO"
///  - Visa ICBC: "DD Mon DD NNNNNN * DESCRIPCION [REF] MONTO"
class PdfParserService {
  PdfParserService._();

  // ─── Categorías sugeridas por keywords ───────────────────────────────────

  static const Map<String, _CategoryHint> _keywordMap = {
    // Delivery
    'PEDIDOSYA': _CategoryHint('cat_entret', 'Delivery'),
    'RAPPI': _CategoryHint('cat_entret', 'Delivery'),
    'GLOVO': _CategoryHint('cat_entret', 'Delivery'),
    // Supermercados
    'COTO': _CategoryHint('cat_alim', 'Supermercado'),
    'CARREFOUR': _CategoryHint('cat_alim', 'Supermercado'),
    'DISCO': _CategoryHint('cat_alim', 'Supermercado'),
    'JUMBO': _CategoryHint('cat_alim', 'Supermercado'),
    'DIA': _CategoryHint('cat_alim', 'Supermercado'),
    'LUCCIANO': _CategoryHint('cat_alim', 'Alimentación'),
    // Streaming
    'NETFLIX': _CategoryHint('cat_entret', 'Entretenimiento'),
    'DISNEY': _CategoryHint('cat_entret', 'Entretenimiento'),
    'SPOTIFY': _CategoryHint('cat_entret', 'Entretenimiento'),
    'HBO': _CategoryHint('cat_entret', 'Entretenimiento'),
    'PARAMOUNT': _CategoryHint('cat_entret', 'Entretenimiento'),
    'AMAZON': _CategoryHint('cat_entret', 'Entretenimiento'),
    'YOUTUBE': _CategoryHint('cat_entret', 'Entretenimiento'),
    'CINE': _CategoryHint('cat_entret', 'Cine'),
    // Combustible / transporte
    'SHELL': _CategoryHint('cat_transp', 'Combustible'),
    'YPF': _CategoryHint('cat_transp', 'Combustible'),
    'AXION': _CategoryHint('cat_transp', 'Combustible'),
    'PETROBRAS': _CategoryHint('cat_transp', 'Combustible'),
    'JETSMART': _CategoryHint('cat_transp', 'Viajes'),
    'AEROLINEAS': _CategoryHint('cat_transp', 'Viajes'),
    'LATAM': _CategoryHint('cat_transp', 'Viajes'),
    'AEROL': _CategoryHint('cat_transp', 'Viajes'),
    'DESPEGAR': _CategoryHint('cat_transp', 'Viajes'),
    'UBER': _CategoryHint('cat_transp', 'Transporte'),
    'CABIFY': _CategoryHint('cat_transp', 'Transporte'),
    // Farmacias / salud
    'FCIA': _CategoryHint('cat_salud', 'Farmacia'),
    'FARMACIA': _CategoryHint('cat_salud', 'Farmacia'),
    'SANC': _CategoryHint('cat_salud', 'Salud'),
    'MUTUAL': _CategoryHint('cat_salud', 'Salud'),
    // Compras online
    'MERCADOLIBRE': _CategoryHint('cat_otros_gasto', 'Compras online'),
    'MERPAGO': _CategoryHint('cat_otros_gasto', 'Compras online'),
    'TIENDAMIA': _CategoryHint('cat_otros_gasto', 'Compras online'),
    'MONOBLOCK': _CategoryHint('cat_tecno', 'Tecnología'),
    'DIGGIT': _CategoryHint('cat_tecno', 'Tecnología'),
    // Ropa
    'MANKI': _CategoryHint('cat_ropa', 'Ropa'),
    'ZARA': _CategoryHint('cat_ropa', 'Ropa'),
    'KEOPS': _CategoryHint('cat_ropa', 'Ropa'),
    // Servicios / membresías
    'DESPEGAR MEMB': _CategoryHint('cat_serv', 'Servicios'),
    'MEMBRESIA': _CategoryHint('cat_serv', 'Servicios'),
    // Ferretería / hogar
    'NEUMATI': _CategoryHint('cat_hogar', 'Hogar / Auto'),
  };

  // ─── Meses en español (Mastercard usa abreviaturas de 3 letras) ──────────

  static const Map<String, int> _meses = {
    'Ene': 1, 'Feb': 2, 'Mar': 3, 'Abr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Ago': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dic': 12,
    // Visa usa nombres completos en el header
    'Enero': 1, 'Febrero': 2, 'Marzo': 3, 'Abril': 4, 'Mayo': 5, 'Junio': 6,
    'Julio': 7, 'Agosto': 8, 'Septiembre': 9, 'Octubre': 10, 'Noviembre': 11, 'Diciembre': 12,
  };

  // ─── API pública ─────────────────────────────────────────────────────────

  /// Extrae el texto completo de un PDF dado sus bytes.
  static String extractText(Uint8List bytes) {
    final document = PdfDocument(inputBytes: bytes);
    final extractor = PdfTextExtractor(document);
    final buffer = StringBuffer();
    for (int i = 0; i < document.pages.count; i++) {
      buffer.writeln(extractor.extractText(startPageIndex: i, endPageIndex: i));
    }
    document.dispose();
    return buffer.toString();
  }

  /// Detecta el formato del PDF y parsea las transacciones.
  static List<ParsedTransaction> parse(String text) {
    final format = _detectFormat(text);
    switch (format) {
      case CardFormat.mastercardICBC:
        return _parseMastercard(text);
      case CardFormat.visaICBC:
        return _parseVisa(text);
      case CardFormat.unknown:
        return [];
    }
  }

  /// Detecta el banco/formato a partir del texto extraído.
  static CardFormat detectFormat(String text) => _detectFormat(text);

  // ─── Detección ───────────────────────────────────────────────────────────

  static CardFormat _detectFormat(String text) {
    if (text.contains('MASTCLI') || text.contains('MASTERCARD')) {
      return CardFormat.mastercardICBC;
    }
    if (text.contains('EXCLUSIVE ICBC CLUB') || text.contains('TARJETA 2550') || text.contains('Visa ICBC')) {
      return CardFormat.visaICBC;
    }
    return CardFormat.unknown;
  }

  // ─── Parser Mastercard ICBC ───────────────────────────────────────────────
  //
  // Formato compras: "DD-Mon-YY DESCRIPCION NNNNN MONTO"
  // Formato cuotas:  "DD-Mon-YY DESCRIPCION CC/TT NNNNN MONTO"
  // Montos: "26040,00" o "1.522.588,23" (punto = miles, coma = decimal)

  static List<ParsedTransaction> _parseMastercard(String text) {
    final results = <ParsedTransaction>[];

    // Regex para cuotas: fecha, descripción, cuota CC/TT, voucher, monto
    final cuotaRe = RegExp(
      r'^(\d{2}-\w{3}-\d{2})\s+([A-Z0-9*.\s]+?)\s+(\d{2}/\d{2})\s+(\d{5})\s+([\d.]+,\d{2})\s*$',
      multiLine: true,
    );

    // Regex para compras simples: fecha, descripción, voucher, monto
    final compraRe = RegExp(
      r'^(\d{2}-\w{3}-\d{2})\s+([A-Z0-9*.\s]+?)\s+(\d{5})\s+([\d.]+,\d{2})\s*$',
      multiLine: true,
    );

    // Primero procesar cuotas (tienen el patrón más específico)
    final cuotasMatched = <String>{};
    for (final m in cuotaRe.allMatches(text)) {
      final line = m.group(0)!;
      cuotasMatched.add(line);
      final date = _parseMcDate(m.group(1)!);
      if (date == null) continue;
      final desc = _cleanDescription(m.group(2)!);
      final cuotaParts = m.group(3)!.split('/');
      final current = int.tryParse(cuotaParts[0]);
      final total = int.tryParse(cuotaParts[1]);
      final amount = _parseAmount(m.group(5)!);
      if (amount <= 0) continue;

      results.add(ParsedTransaction(
        date: date,
        description: desc,
        amount: amount,
        isInstallment: true,
        installmentCurrent: current,
        installmentTotal: total,
        suggestedCategoryId: _suggestCategory(desc).id,
        suggestedCategoryName: _suggestCategory(desc).name,
      ));
    }

    // Luego compras simples (evitando las ya procesadas como cuotas)
    for (final m in compraRe.allMatches(text)) {
      final line = m.group(0)!;
      if (cuotasMatched.contains(line)) continue;
      final date = _parseMcDate(m.group(1)!);
      if (date == null) continue;
      final desc = _cleanDescription(m.group(2)!);
      final amount = _parseAmount(m.group(4)!);
      if (amount <= 0) continue;

      results.add(ParsedTransaction(
        date: date,
        description: desc,
        amount: amount,
        suggestedCategoryId: _suggestCategory(desc).id,
        suggestedCategoryName: _suggestCategory(desc).name,
      ));
    }

    // Ordenar por fecha
    results.sort((a, b) => a.date.compareTo(b.date));
    return results;
  }

  // ─── Parser Visa ICBC ────────────────────────────────────────────────────
  //
  // Formato: "[DD Mon] DD NNNNNN * DESCRIPCION [REF_LARGA] MONTO"
  // Los primeros DD Mon son la fecha de cierre (pueden no repetirse en cada línea).
  // El segundo DD es el día de la transacción.
  // Extraemos el año/mes del header: "CIERRE 26 Mar 26"

  static List<ParsedTransaction> _parseVisa(String text) {
    final results = <ParsedTransaction>[];

    // Extraer mes y año de cierre del header, ej: "CIERRE 26 Mar 26"
    final headerRe = RegExp(r'CIERRE\s+\d+\s+(\w+)\s+(\d{2})');
    int baseYear = DateTime.now().year;
    int baseMonth = DateTime.now().month;
    final headerMatch = headerRe.firstMatch(text);
    if (headerMatch != null) {
      final mesStr = headerMatch.group(1)!;
      final yearShort = int.tryParse(headerMatch.group(2)!) ?? 0;
      baseYear = 2000 + yearShort;
      baseMonth = _meses[mesStr] ?? baseMonth;
    }

    // Regex: DD NNNNNN * DESCRIPCION [REF_LARGA] MONTO
    // REF_LARGA es un número largo (>=10 dígitos) que puede aparecer al final
    final txRe = RegExp(
      r'^\s*(?:\d{1,2}\s+\w+\s+)?(\d{1,2})\s+(\d{6})\s+\*\s+([A-Z0-9 ]+?)\s+(?:\d{10,20}\s+)?([\d.]+,\d{2})\s*$',
      multiLine: true,
    );

    for (final m in txRe.allMatches(text)) {
      final day = int.tryParse(m.group(1)!) ?? 1;
      final desc = _cleanDescription(m.group(3)!);
      final amount = _parseAmount(m.group(4)!);
      if (amount <= 0) continue;

      // El día puede ser de un mes anterior al cierre (transacciones del período anterior)
      // Heurística: si day > 20 y baseMonth == 3 → probablemente febrero
      int txMonth = baseMonth;
      int txYear = baseYear;
      if (day > 20 && baseMonth > 1) {
        txMonth = baseMonth - 1;
      }

      results.add(ParsedTransaction(
        date: DateTime(txYear, txMonth, day),
        description: desc,
        amount: amount,
        suggestedCategoryId: _suggestCategory(desc).id,
        suggestedCategoryName: _suggestCategory(desc).name,
      ));
    }

    results.sort((a, b) => a.date.compareTo(b.date));
    return results;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// "26.040,00" o "1.522.588,23" → double
  static double _parseAmount(String raw) {
    final cleaned = raw.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }

  /// "19-Feb-26" → DateTime(2026, 2, 19)
  static DateTime? _parseMcDate(String raw) {
    final parts = raw.split('-');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = _meses[parts[1]];
    final yearShort = int.tryParse(parts[2]);
    if (day == null || month == null || yearShort == null) return null;
    return DateTime(2000 + yearShort, month, day);
  }

  /// Limpia y normaliza la descripción (elimina espacios extra, trim).
  static String _cleanDescription(String raw) {
    return raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Devuelve la categoría sugerida basada en keywords en la descripción.
  static _CategoryHint _suggestCategory(String description) {
    final upper = description.toUpperCase();
    for (final entry in _keywordMap.entries) {
      if (upper.contains(entry.key)) return entry.value;
    }
    return const _CategoryHint('cat_otros_gasto', 'Otros gastos');
  }
}

class _CategoryHint {
  const _CategoryHint(this.id, this.name);
  final String id;
  final String name;
}
