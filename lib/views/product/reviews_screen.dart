import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/review_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/rating_stars.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/review_model.dart';
import 'create_review_screen.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late final String _tag;
  late final ReviewController _c;

  @override
  void initState() {
    super.initState();
    _tag = 'reviews_${widget.productId}_${identityHashCode(this)}';
    _c = Get.put(ReviewController(widget.productId), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<ReviewController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reviews')),
      body: Obx(() {
        if (_c.isLoading.value) return const LoadingView();
        if (_c.errorMessage.value != null && _c.reviews.isEmpty) {
          return ErrorState(message: _c.errorMessage.value!, onRetry: _c.load);
        }
        if (_c.reviews.isEmpty) {
          return const EmptyState(
            icon: Icons.rate_review_outlined,
            title: 'No reviews yet',
            message: 'Be the first to share what you think about this product.',
          );
        }
        return RefreshIndicator(
          onRefresh: _c.load,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _c.reviews.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ReviewTile(review: _c.reviews[i]),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Obx(() => Text(
                    'Reviews (${_c.reviews.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              const Spacer(),
              FloatingActionButton(
                heroTag: 'add_review_$_tag',
                mini: true,
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                onPressed: () => Get.to(() => CreateReviewScreen(controller: _c)),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person_outline, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (review.createdAt.isNotEmpty)
                      Text(
                        Formatters.date(review.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                  ],
                ),
              ),
              if (review.rating > 0) RatingStars(rating: review.rating, size: 15),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(color: AppColors.textGrey, height: 1.45),
          ),
        ],
      ),
    );
  }
}