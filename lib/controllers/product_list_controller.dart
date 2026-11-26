import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/models/product_model.dart';

class ProductListController extends GetxController {
  ProductListController({this.categoryId, this.tag, this.search});

  final String? categoryId;
  final String? tag;
  final String? search;

  static const int _pageSize = 20;

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxnString errorMessage = RxnString();

  int _page = 1;
  bool _hasMore = true;
  bool _useTag = true;

  bool get _isSearch => search != null && search!.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    _page = 1;
    _hasMore = true;
    _useTag = true;
    isLoading.value = true;
    errorMessage.value = null;
    products.clear();
    await _fetch();
    isLoading.value = false;
  }

  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value || !_hasMore) return;
    isLoadingMore.value = true;
    _page++;
    await _fetch();
    isLoadingMore.value = false;
  }

  Future<void> _fetch() async {
    final res = await ApiClient.get(AppUrls.products(
      page: _page,
      count: _isSearch ? 100 : _pageSize,
      category: categoryId,
      tag: _useTag ? tag : null,
    ));

    if (!res.isSuccess) {
      if (_page > 1) _page--;
      if (products.isEmpty) errorMessage.value = res.errorMessage;
      return;
    }

    var items = Json.maps(res.data).map(Product.fromJson).toList();

    // Tag matched nothing: show the normal list instead of an empty page.
    if (_page == 1 && items.isEmpty && tag != null && _useTag) {
      _useTag = false;
      return _fetch();
    }

    if (_isSearch) {
      final q = search!.trim().toLowerCase();
      items = items.where((p) => p.title.toLowerCase().contains(q)).toList();
      _hasMore = false;
    } else {
      _hasMore = items.length >= _pageSize;
    }

    final known = products.map((p) => p.id).toSet();
    products.addAll(items.where((p) => !known.contains(p.id)));
  }
}