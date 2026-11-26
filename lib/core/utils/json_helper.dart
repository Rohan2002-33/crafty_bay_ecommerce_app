/// Small helpers so models survive slightly different API shapes.
class Json {
  Json._();

  static const List<String> _listKeys = [
    'data', 'items', 'docs', 'results', 'products', 'categories',
    'slides', 'orders', 'reviews', 'cart', 'wishlist',
  ];

  static String str(dynamic v, [String fallback = '']) {
    if (v == null) return fallback;
    final s = v.toString();
    return s.isEmpty ? fallback : s;
  }

  static double dbl(dynamic v, [double fallback = 0]) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? fallback;
  }

  static int integer(dynamic v, [int fallback = 0]) {
    if (v is num) return v.toInt();
    return int.tryParse('$v') ?? fallback;
  }

  static List<dynamic> list(dynamic v) => v is List ? v : const [];

  static Map<String, dynamic> map(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

  static String id(Map<String, dynamic> j) => str(j['_id'] ?? j['id']);

  /// Finds the first list inside a response, whatever the wrapper is.
  static List<dynamic> extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map) {
      for (final key in _listKeys) {
        final value = body[key];
        if (value is List) return value;
        if (value is Map) {
          final inner = extractList(value);
          if (inner.isNotEmpty) return inner;
        }
      }
    }
    return const [];
  }

  static List<Map<String, dynamic>> maps(dynamic body) =>
      extractList(body).whereType<Map>().map(map).toList();

  /// Unwraps `{ data: {...} }` style responses. [keys] = wrapper keys to open.
  static Map<String, dynamic> extractMap(
    dynamic body, {
    List<String> keys = const ['data'],
  }) {
    dynamic current = body;
    for (var depth = 0; depth < 3; depth++) {
      if (current is! Map) break;
      final m = map(current);
      dynamic inner;
      for (final k in keys) {
        if (m[k] is Map) {
          inner = m[k];
          break;
        }
      }
      if (inner == null) return m;
      current = inner;
    }
    return map(current);
  }

  /// Depth-first search for the first non-empty value under any of [keys].
  static String? findString(dynamic body, List<String> keys, {String? exclude}) {
    if (body is Map) {
      for (final k in keys) {
        final v = body[k];
        if (v is String && v.isNotEmpty && v != exclude) return v;
        if (v is num) return v.toString();
      }
      for (final v in body.values) {
        final found = findString(v, keys, exclude: exclude);
        if (found != null) return found;
      }
    } else if (body is List) {
      for (final v in body) {
        final found = findString(v, keys, exclude: exclude);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Looks for the payment gateway link inside an order response.
  static String? findPaymentUrl(dynamic body, {required String exclude}) {
    final direct = findString(
      body,
      ['payment_url', 'paymentUrl', 'GatewayPageURL', 'gateway_url',
        'gatewayUrl', 'checkout_url', 'url', 'link'],
      exclude: exclude,
    );
    if (direct != null && direct.startsWith('http')) return direct;
    return _findHttp(body, exclude);
  }

  static String? _findHttp(dynamic body, String exclude) {
    if (body is String) {
      final lower = body.toLowerCase();
      final looksLikePayment = lower.contains('sslcommerz') ||
          lower.contains('gateway') ||
          lower.contains('payment');
      if (body.startsWith('http') && body != exclude && looksLikePayment) {
        return body;
      }
    } else if (body is Map) {
      for (final v in body.values) {
        final found = _findHttp(v, exclude);
        if (found != null) return found;
      }
    } else if (body is List) {
      for (final v in body) {
        final found = _findHttp(v, exclude);
        if (found != null) return found;
      }
    }
    return null;
  }
}