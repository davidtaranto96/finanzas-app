/// Parses financial notification text to extract expense data.
///
/// Supports major Argentine financial apps by package name.
class NotificationExpenseParser {
  /// Known financial app package names mapped to display names.
  static const knownApps = <String, String>{
    'com.mercadopago.wallet': 'Mercado Pago',
    'com.mosync.app_Galicia': 'Galicia',
    'com.bbva.nxt_argentina': 'BBVA',
    'ar.com.santander.rio.mbanking': 'Santander',
    'brubank.com.ar': 'Brubank',
    'com.uala': 'Ualá',
    'com.naranja.nxt': 'Naranja X',
    'ar.com.personal.pay': 'Personal Pay',
    'ar.com.macro': 'Macro',
    'com.bind.app': 'Bind',
  };

  /// Returns true if the package name belongs to a known financial app.
  static bool isFinancialApp(String packageName) =>
      knownApps.containsKey(packageName);

  /// Attempts to extract expense info from a notification.
  /// Returns null if parsing fails or the notification isn't a payment.
  static ParsedExpense? parse({
    required String packageName,
    required String? title,
    required String? text,
  }) {
    final content = '${title ?? ''} ${text ?? ''}'.trim();
    if (content.isEmpty) return null;

    // Skip non-payment notifications (promos, security, etc.)
    final lowerContent = content.toLowerCase();
    if (_isNonPayment(lowerContent)) return null;

    final amount = _extractAmount(content);
    if (amount == null || amount <= 0) return null;

    final description = _extractDescription(content, packageName);
    final appName = knownApps[packageName] ?? 'Desconocido';

    return ParsedExpense(
      amount: amount,
      description: description,
      appName: appName,
      packageName: packageName,
      rawText: content,
    );
  }

  /// Extracts monetary amount from text.
  /// Handles: $1.234, $1.234,56, $1234, $ 5.200
  static double? _extractAmount(String text) {
    // Match patterns like $1.234,56 or $1234 or $1.234
    final patterns = [
      // $1.234,56 or $1.234.567,89
      RegExp(r'\$\s?([\d]{1,3}(?:\.[\d]{3})*,[\d]{1,2})'),
      // $1234.56
      RegExp(r'\$\s?([\d]+\.[\d]{1,2})(?!\d)'),
      // $1.234 (no decimals)
      RegExp(r'\$\s?([\d]{1,3}(?:\.[\d]{3})+)(?!,)'),
      // $1234
      RegExp(r'\$\s?([\d]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        var numStr = match.group(1)!;
        // Argentine format: 1.234,56 → 1234.56
        if (numStr.contains(',')) {
          numStr = numStr.replaceAll('.', '').replaceAll(',', '.');
        } else if (numStr.contains('.')) {
          // Could be 1.234 (thousands) or 12.50 (decimals)
          final parts = numStr.split('.');
          if (parts.length == 2 && parts.last.length == 3) {
            // 1.234 → thousands separator
            numStr = numStr.replaceAll('.', '');
          }
          // else keep as-is (12.50 is decimal)
        }
        final parsed = double.tryParse(numStr);
        if (parsed != null && parsed > 0) return parsed;
      }
    }
    return null;
  }

  /// Extracts a description/merchant name from the notification text.
  static String _extractDescription(String text, String packageName) {
    // Try to find "en <merchant>" pattern
    final enMatch = RegExp(r'(?:en|a)\s+([A-Z][\w\s&*.-]+)', caseSensitive: false)
        .firstMatch(text);
    if (enMatch != null) {
      return enMatch.group(1)!.trim();
    }

    // Try "Pagaste a <name>" or "Transferiste a <name>"
    final aMatch = RegExp(r'(?:Pagaste|Transferiste|Enviaste)\s+(?:a\s+)?(.+?)(?:\s+\$|\s*$)',
            caseSensitive: false)
        .firstMatch(text);
    if (aMatch != null) {
      return aMatch.group(1)!.trim();
    }

    // Fallback: use app name
    return knownApps[packageName] ?? 'Gasto';
  }

  /// Filters out non-payment notifications.
  static bool _isNonPayment(String lowerText) {
    const skipKeywords = [
      'promoción', 'promocion', 'descuento exclusivo',
      'oferta', 'cashback', 'rendimiento',
      'código de seguridad', 'codigo de seguridad',
      'verificación', 'verificacion',
      'inicio de sesión', 'inicio de sesion',
      'contraseña', 'contrasena',
      'recibiste', // Income, not expense
      'te transfirieron', // Income
      'te enviaron', // Income
      'depósito', 'deposito', // Income
    ];
    return skipKeywords.any(lowerText.contains);
  }
}

/// Parsed expense from a financial notification.
class ParsedExpense {
  final double amount;
  final String description;
  final String appName;
  final String packageName;
  final String rawText;

  const ParsedExpense({
    required this.amount,
    required this.description,
    required this.appName,
    required this.packageName,
    required this.rawText,
  });
}
