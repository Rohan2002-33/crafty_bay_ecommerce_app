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

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;

    final results = await Future.wait([
      ApiClient.get(AppUrls.slides),
      ApiClient.get(AppUrls.categories),
      ApiClient.get(AppUrls.products(page: 1, count: 40)),
    ]);
    final slideRes = results[0];
    final categoryRes = results[1];
    final productRes = results[2];

    if (!categoryRes.isSuccess && !productRes.isSuccess) {
      errorMessage.value = productRes.errorMessage;
      isLoading.value = false;
      return;
    }

    if (slideRes.isSuccess) {
      slides.assignAll(Json.maps(slideRes.data).map(SlideModel.fromJson));
    }
    if (categoryRes.isSuccess) {
      categories.assignAll(Json.maps(categoryRes.data).map(CategoryModel.fromJson));
    }

    final all = productRes.isSuccess
        ? Json.maps(productRes.data).map(Product.fromJson).toList()
        : <Product>[];

    // Use tagged products when the API has them, else fall back to the list.
    final tagged = await Future.wait([
      _byTag('popular'),
      _byTag('special'),
      _byTag('new'),
    ]);
    popular.assignAll(tagged[0].isNotEmpty ? tagged[0] : all.take(10));
    special.assignAll(tagged[1].isNotEmpty ? tagged[1] : all.skip(5).take(10));
    newest.assignAll(tagged[2].isNotEmpty ? tagged[2] : all.reversed.take(10));

    isLoading.value = false;
  }

  Future<List<Product>> _byTag(String tag) async {
    final res = await ApiClient.get(AppUrls.products(tag: tag, count: 10));
    if (!res.isSuccess) return [];
    return Json.maps(res.data).map(Product.fromJson).toList();
  }
}