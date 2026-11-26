import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/data_sources/app_catalog.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/models/slide_model.dart';

class HomeController extends GetxController {
  final RxList<SlideModel> slides = <SlideModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<Product> popular = <Product>[].obs;
  final RxList<Product> special = <Product>[].obs;
  final RxList<Product> newest = <Product>[].obs;
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    _populateDefaultData();
    load();
  }

  void _populateDefaultData() {
    if (categories.isEmpty) {
      categories.assignAll(AppCatalog.categories);
    }

    if (popular.isEmpty) popular.assignAll(AppCatalog.getByTag('popular'));
    if (special.isEmpty) special.assignAll(AppCatalog.getByTag('special'));
    if (newest.isEmpty) newest.assignAll(AppCatalog.getByTag('new'));
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final results = await Future.wait([
        ApiClient.get(AppUrls.slides),
        ApiClient.get(AppUrls.categories),
        ApiClient.get(AppUrls.products(page: 1, count: 50)),
      ]);
      final slideRes = results[0];
      final categoryRes = results[1];
      final productRes = results[2];

      if (slideRes.isSuccess && slideRes.data != null) {
        final loadedSlides = Json.maps(slideRes.data).map(SlideModel.fromJson).toList();
        if (loadedSlides.isNotEmpty) slides.assignAll(loadedSlides);
      }

      if (categoryRes.isSuccess && categoryRes.data != null) {
        final loadedCats = Json.maps(categoryRes.data)
            .map(CategoryModel.fromJson)
            .where((c) {
              final title = c.title.trim().toLowerCase();
              return title.isNotEmpty &&
                  !title.contains('catfgh') &&
                  !title.contains('trampolin') &&
                  !title.contains('asdasd') &&
                  title != 'new category';
            })
            .toList();

        if (loadedCats.isNotEmpty) {
          // Merge with core categories, keeping unique category titles
          final seen = <String>{};
          final merged = <CategoryModel>[];
          for (final c in AppCatalog.categories) {
            final t = c.title.toLowerCase();
            if (seen.add(t)) merged.add(c);
          }
          for (final c in loadedCats) {
            final t = c.title.toLowerCase();
            if (seen.add(t)) merged.add(c);
          }
          categories.assignAll(merged);
        } else {
          categories.assignAll(AppCatalog.categories);
        }
      }

      final rawProducts = (productRes.isSuccess && productRes.data != null)
          ? Json.maps(productRes.data)
              .map(Product.fromJson)
              .where((p) => !AppCatalog.isGarbageProduct(p))
              .map(AppCatalog.sanitize)
              .toList()
          : <Product>[];

      final popularCurated = AppCatalog.getByTag('popular');
      final specialCurated = AppCatalog.getByTag('special');
      final newCurated = AppCatalog.getByTag('new');

      final popularApi = rawProducts.where((p) => p.tags.contains('popular') || p.tags.contains('special')).toList();
      final specialApi = rawProducts.where((p) => p.tags.contains('special')).toList();
      final newApi = rawProducts.where((p) => p.tags.contains('new')).toList();

      popular.assignAll(_mergeProducts(popularCurated, popularApi));
      special.assignAll(_mergeProducts(specialCurated, specialApi));
      newest.assignAll(_mergeProducts(newCurated, newApi));
    } catch (_) {
      // Keep curated catalog data intact if offline
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> _mergeProducts(List<Product> primary, List<Product> secondary) {
    final list = <Product>[...primary];
    final seen = list.map((p) => p.title.toLowerCase().trim()).toSet();
    for (final p in secondary) {
      final t = p.title.toLowerCase().trim();
      if (!seen.contains(t)) {
        list.add(p);
        seen.add(t);
      }
    }
    return list;
  }
}
