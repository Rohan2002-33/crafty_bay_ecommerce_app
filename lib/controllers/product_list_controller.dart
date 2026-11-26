import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/data_sources/app_catalog.dart';
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
    _seedFromCatalog();
    load();
  }

  void _seedFromCatalog() {
    List<Product> initial = [];
    if (_isSearch) {
      initial = AppCatalog.search(search!);
    } else if (categoryId != null && categoryId!.isNotEmpty) {
      initial = AppCatalog.getByCategory(categoryId);
    } else if (tag != null && tag!.isNotEmpty) {
      initial = AppCatalog.getByTag(tag!);
    } else {
      initial = AppCatalog.products;
    }

    if (initial.isNotEmpty) {
      products.assignAll(initial);
      isLoading.value = false;
    }
  }

  Future<void> load() async {
    _page = 1;
    _hasMore = true;
    _useTag = true;
    if (products.isEmpty) isLoading.value = true;
    errorMessage.value = null;
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
      if (products.isEmpty) {
        _seedFromCatalog();
        if (products.isEmpty) errorMessage.value = res.errorMessage;
      }
      return;
    }

    var items = Json.maps(res.data)
        .map(Product.fromJson)
        .where((p) => !AppCatalog.isGarbageProduct(p))
        .map(AppCatalog.sanitize)
        .toList();

    // Tag matched nothing: retry without tag constraint
    if (_page == 1 && items.isEmpty && tag != null && _useTag) {
      _useTag = false;
      return _fetch();
    }

    if (_isSearch) {
      final q = search!.trim().toLowerCase();
      items = items.where((p) => p.title.toLowerCase().contains(q)).toList();
      _hasMore = false;
    } else if (categoryId != null && categoryId!.isNotEmpty) {
      final cQuery = categoryId!.toLowerCase();
      items = items.where((p) {
        final cTitle = p.categoryTitle.toLowerCase();
        final cId = p.categoryId.toLowerCase();
        return cTitle.contains(cQuery) ||
            cId.contains(cQuery) ||
            cQuery.contains(cTitle) ||
            cQuery.contains(cId);
      }).toList();
      _hasMore = items.length >= _pageSize;
    } else {
      _hasMore = items.length >= _pageSize;
    }

    final knownTitles = products.map((p) => p.title.toLowerCase().trim()).toSet();
    final knownIds = products.map((p) => p.id).toSet();

    for (final item in items) {
      final t = item.title.toLowerCase().trim();
      if (!knownTitles.contains(t) && !knownIds.contains(item.id)) {
        products.add(item);
        knownTitles.add(t);
        knownIds.add(item.id);
      }
    }

    if (products.isEmpty) {
      _seedFromCatalog();
    }
  }
}
