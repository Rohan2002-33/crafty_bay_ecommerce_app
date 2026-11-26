import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
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
      categories.assignAll(const [
        CategoryModel(id: 'cat_electronics', title: 'Electronics', icon: ''),
        CategoryModel(id: 'cat_food', title: 'Food', icon: ''),
        CategoryModel(id: 'cat_fashion', title: 'Fashion', icon: ''),
        CategoryModel(id: 'cat_furniture', title: 'Furniture', icon: ''),
        CategoryModel(id: 'cat_sports', title: 'Sports', icon: ''),
        CategoryModel(id: 'cat_kids', title: 'Kids', icon: ''),
        CategoryModel(id: 'cat_beauty', title: 'Beauty', icon: ''),
        CategoryModel(id: 'cat_appliances', title: 'Appliances', icon: ''),
      ]);
    }

    final demoProducts = List.generate(
      8,
      (i) => Product(
        id: 'demo_shoe_$i',
        title: 'New Year Special Shoe ${i + 1}',
        description:
            'Nike sports shoes for men features a comfortable mesh upper and a lightweight Phylon midsole. A rubber outsole provides traction and durability.',
        photos: const [],
        colors: const ['Red', 'Blue', 'Grey', 'Black'],
        sizes: const ['S', 'M', 'L', 'XL', 'XXL'],
        currentPrice: 100.0 + (i * 10),
        regularPrice: 150.0 + (i * 10),
        rating: 4.8,
      ),
    );

    if (popular.isEmpty) popular.assignAll(demoProducts);
    if (special.isEmpty) special.assignAll(demoProducts.reversed.toList());
    if (newest.isEmpty) newest.assignAll(demoProducts);
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final results = await Future.wait([
        ApiClient.get(AppUrls.slides),
        ApiClient.get(AppUrls.categories),
        ApiClient.get(AppUrls.products(page: 1, count: 40)),
      ]);
      final slideRes = results[0];
      final categoryRes = results[1];
      final productRes = results[2];

      if (slideRes.isSuccess && slideRes.data != null) {
        final loadedSlides = Json.maps(slideRes.data).map(SlideModel.fromJson).toList();
        if (loadedSlides.isNotEmpty) slides.assignAll(loadedSlides);
      }
      if (categoryRes.isSuccess && categoryRes.data != null) {
        final loadedCats = Json.maps(categoryRes.data).map(CategoryModel.fromJson).toList();
        if (loadedCats.isNotEmpty) categories.assignAll(loadedCats);
      }

      final all = (productRes.isSuccess && productRes.data != null)
          ? Json.maps(productRes.data).map(Product.fromJson).toList()
          : <Product>[];

      if (all.isNotEmpty) {
        final tagged = await Future.wait([
          _byTag('popular'),
          _byTag('special'),
          _byTag('new'),
        ]);
        popular.assignAll(tagged[0].isNotEmpty ? tagged[0] : all.take(10));
        special.assignAll(tagged[1].isNotEmpty ? tagged[1] : all.skip(5).take(10));
        newest.assignAll(tagged[2].isNotEmpty ? tagged[2] : all.reversed.take(10));
      }
    } catch (_) {
      // Keep demo data intact if offline
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Product>> _byTag(String tag) async {
    try {
      final res = await ApiClient.get(AppUrls.products(tag: tag, count: 10));
      if (!res.isSuccess) return [];
      return Json.maps(res.data).map(Product.fromJson).toList();
    } catch (_) {
      return [];
    }
  }
}
