import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/models/review_model.dart';

class ReviewController extends GetxController {
  ReviewController(this.productId);

  final String productId;

  final RxList<Review> reviews = <Review>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isSubmitting = false.obs;
  final RxnString errorMessage = RxnString();
  String lastError = '';

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    final res = await ApiClient.get(AppUrls.reviews(productId));
    if (res.isSuccess) {
      reviews.assignAll(Json.maps(res.data).map(Review.fromJson));
    } else {
      errorMessage.value = res.errorMessage;
    }
    isLoading.value = false;
  }

  Future<bool> submit({required String comment, required int rating}) async {
    isSubmitting.value = true;
    final res = await ApiClient.post(AppUrls.review, body: {
      'product': productId,
      'comment': comment,
      'rating': rating,
    });
    isSubmitting.value = false;

    if (!res.isSuccess) {
      lastError = res.errorMessage;
      return false;
    }
    await load();
    return true;
  }
}