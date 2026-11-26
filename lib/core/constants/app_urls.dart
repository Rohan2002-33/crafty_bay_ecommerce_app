class AppUrls {
  AppUrls._();

  static const String _base = 'https://ecom-rs8e.onrender.com/api';

  /// Payment gateway sends the customer here after paying.
  /// The WebView screen watches for this address.
  static const String paymentRedirect =
      'https://jsonplaceholder.typicode.com/posts';

  static const String login = '$_base/auth/login';
  static const String signup = '$_base/auth/signup';
  static const String verifyOtp = '$_base/auth/verify-otp';
  static const String resendOtp = '$_base/auth/resend-otp';
  static const String profile = '$_base/auth/profile';
  static const String slides = '$_base/slides';
  static const String categories = '$_base/categories';
  static const String cart = '$_base/cart';
  static const String wishlist = '$_base/wishlist';
  static const String review = '$_base/review';
  static const String order = '$_base/order';
  static const String orders = '$_base/orders';

  static String products({int? page, int? count, String? category, String? tag}) {
    final query = <String, String>{
      if (page != null) 'page': '$page',
      if (count != null) 'count': '$count',
      if (category != null && category.isNotEmpty) 'category': category,
      if (tag != null && tag.isNotEmpty) 'tag': tag,
    };
    return Uri.parse('$_base/products')
        .replace(queryParameters: query.isEmpty ? null : query)
        .toString();
  }

  static String productById(String id) => '$_base/products/id/$id';
  static String reviews(String productId) =>
      '$_base/reviews?product=$productId&count=100';
  static String cartItem(String id) => '$_base/cart/$id';
  static String wishlistItem(String id) => '$_base/wishlist/$id';
  static String orderById(String id) => '$_base/orders/$id';
  static String cancelOrder(String id) => '$_base/orders/$id/cancel';
}