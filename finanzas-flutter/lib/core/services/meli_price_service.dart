import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Result of a MeLi price check.
class MeliPriceResult {
  final String itemId;
  final String title;
  final double price;
  final double? originalPrice;
  final String? thumbnail;
  final String permalink;
  final String currencyId;
  final DateTime checkedAt;

  const MeliPriceResult({
    required this.itemId,
    required this.title,
    required this.price,
    this.originalPrice,
    this.thumbnail,
    required this.permalink,
    this.currencyId = 'ARS',
    required this.checkedAt,
  });

  /// Discount percentage (if originalPrice exists and is higher).
  double? get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice! * 100);
  }
}

/// Search result from MeLi.
class MeliSearchResult {
  final String itemId;
  final String title;
  final double price;
  final double? originalPrice;
  final String? thumbnail;
  final String permalink;
  final int? installmentQty;
  final double? installmentAmount;
  final bool freeShipping;

  const MeliSearchResult({
    required this.itemId,
    required this.title,
    required this.price,
    this.originalPrice,
    this.thumbnail,
    required this.permalink,
    this.installmentQty,
    this.installmentAmount,
    this.freeShipping = false,
  });

  /// Discount percentage (if originalPrice exists and is higher).
  double? get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((originalPrice! - price) / originalPrice! * 100);
  }
}

class MeliPriceService {
  static const _baseUrl = 'https://api.mercadolibre.com';
  static const _timeout = Duration(seconds: 10);
  static const _tokenKey = 'mp_access_token';

  /// Extract MeLi item ID from a URL.
  /// Supports:
  ///   - https://articulo.mercadolibre.com.ar/MLA-123456789-titulo
  ///   - https://www.mercadolibre.com.ar/.../p/MLA12345678
  ///   - https://producto.mercadolibre.com.ar/MLA-123456789
  ///   - https://mercadolibre.com.ar/.../_JM (product page)
  ///   - Short IDs in URL: /noindex/.../MLA1234567890/...
  static String? extractItemId(String url) {
    final lower = url.toLowerCase();
    if (!lower.contains('mercadolibre') && !lower.contains('meli')) return null;

    // Pattern 1: MLA-123456789 or MLA123456789 anywhere in URL
    final dashPattern = RegExp(r'(MLA[\-]?\d{6,15})', caseSensitive: false);
    final dashMatch = dashPattern.firstMatch(url);
    if (dashMatch != null) {
      // Normalize: ensure format is MLA123456789 (no dash)
      final raw = dashMatch.group(1)!.replaceAll('-', '').toUpperCase();
      // Keep only 'MLA' prefix + digits
      final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
      return 'MLA$digits';
    }

    // Pattern 2: /p/MLA12345678
    final pPattern = RegExp(r'/p/(MLA\d+)', caseSensitive: false);
    final pMatch = pPattern.firstMatch(url);
    if (pMatch != null) {
      return pMatch.group(1)!.toUpperCase();
    }

    return null;
  }

  /// Check if a URL looks like a MeLi product URL (has item ID).
  static bool isValidProductUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return extractItemId(url) != null;
  }

  /// Last error message for debugging.
  static String? lastError;

  /// Get stored MP access token (shared with Mercado Pago).
  static Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Build headers, optionally with auth token.
  static Map<String, String> _headers({String? token}) {
    final h = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  /// Fetch current price for a MeLi item by ID.
  /// Tries with MP access token first, then without.
  static Future<MeliPriceResult?> fetchItemPrice(String itemId) async {
    lastError = null;
    final token = await _getAccessToken();

    // Try with token first if available
    if (token != null && token.isNotEmpty) {
      final result = await _fetchItemPriceWithHeaders(itemId, _headers(token: token));
      if (result != null) return result;
    }

    // Try without token as fallback
    final result = await _fetchItemPriceWithHeaders(itemId, _headers());
    return result;
  }

  static Future<MeliPriceResult?> _fetchItemPriceWithHeaders(
      String itemId, Map<String, String> headers) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/items/$itemId'),
        headers: headers,
      ).timeout(_timeout);

      if (response.statusCode == 403) {
        lastError = 'API requiere autenticación (403)';
        return null;
      }
      if (response.statusCode == 401) {
        lastError = 'Token expirado o inválido (401)';
        return null;
      }
      if (response.statusCode != 200) {
        lastError = 'HTTP ${response.statusCode}';
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final price = (json['price'] as num?)?.toDouble();
      if (price == null) {
        lastError = 'Sin precio en respuesta';
        return null;
      }

      return MeliPriceResult(
        itemId: json['id'] as String? ?? itemId,
        title: json['title'] as String? ?? '',
        price: price,
        originalPrice: (json['original_price'] as num?)?.toDouble(),
        thumbnail: json['thumbnail'] as String?,
        permalink: json['permalink'] as String? ?? '',
        currencyId: json['currency_id'] as String? ?? 'ARS',
        checkedAt: DateTime.now(),
      );
    } catch (e) {
      lastError = e.toString();
      return null;
    }
  }

  /// Fetch price from a MeLi URL.
  /// Returns null if URL doesn't contain a valid MeLi item ID or API fails.
  static Future<MeliPriceResult?> fetchPriceFromUrl(String url) async {
    final itemId = extractItemId(url);
    if (itemId == null) {
      lastError = 'No se pudo extraer ID del link';
      return null;
    }
    return fetchItemPrice(itemId);
  }

  /// Search MeLi for products matching a query.
  /// Uses the public search endpoint which doesn't require authentication.
  static Future<List<MeliSearchResult>> search(String query, {int limit = 5}) async {
    try {
      // Search endpoint works without auth — don't send token to avoid 403
      final uri = Uri.parse('$_baseUrl/sites/MLA/search')
          .replace(queryParameters: {'q': query, 'limit': '$limit'});

      final response = await http.get(uri, headers: _headers()).timeout(_timeout);
      if (response.statusCode != 200) {
        lastError = 'Búsqueda: HTTP ${response.statusCode}';
        return [];
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? [];

      return results.map((r) {
        final item = r as Map<String, dynamic>;
        // Extract installments info from search results
        final installments = item['installments'] as Map<String, dynamic>?;
        return MeliSearchResult(
          itemId: item['id'] as String? ?? '',
          title: item['title'] as String? ?? '',
          price: (item['price'] as num?)?.toDouble() ?? 0,
          originalPrice: (item['original_price'] as num?)?.toDouble(),
          thumbnail: item['thumbnail'] as String?,
          permalink: item['permalink'] as String? ?? '',
          installmentQty: (installments?['quantity'] as num?)?.toInt(),
          installmentAmount: (installments?['amount'] as num?)?.toDouble(),
          freeShipping: (item['shipping'] as Map<String, dynamic>?)?['free_shipping'] as bool? ?? false,
        );
      }).toList();
    } catch (e) {
      lastError = 'Búsqueda: ${e.toString()}';
      return [];
    }
  }
}
