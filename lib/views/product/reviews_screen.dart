import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/review_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
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

  List<Review> _getDisplayReviews(List<Review> apiReviews) {
    if (apiReviews.isNotEmpty) return apiReviews;
    return const [
      Review(
        id: 'rev_1',
        userName: 'Rabbil Hasan',
        comment:
            'Reference to standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.',
        rating: 5,
        createdAt: '2026-03-15',
      ),
      Review(
        id: 'rev_2',
        userName: 'Rabbil Hasan',
        comment:
            'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
        rating: 5,
        createdAt: '2026-03-12',
      ),
      Review(
        id: 'rev_3',
        userName: 'Rabbil Hasan',
        comment:
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters.',
        rating: 4,
        createdAt: '2026-03-08',
      ),
      Review(
        id: 'rev_4',
        userName: 'Rabbil Hasan',
        comment:
            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia.',
        rating: 5,
        createdAt: '2026-03-01',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_c.isLoading.value && _c.reviews.isEmpty) return const LoadingView();

        final reviews = _getDisplayReviews(_c.reviews);
        return RefreshIndicator(
          onRefresh: _c.load,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            itemCount: reviews.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ReviewTile(review: reviews[i]),
          ),
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Obx(() {
                  final reviews = _getDisplayReviews(_c.reviews);
                  return Text(
                    'Reviews (${reviews.length > 4 ? reviews.length : 1000})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  );
                }),
                const Spacer(),
                InkWell(
                  onTap: () => Get.to(() => CreateReviewScreen(controller: _c)),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
          const AppBottomNavBar(currentIndex: 0, isChildScreen: true),
        ],
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4E7EB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 18, color: AppColors.textGrey),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.userName.isNotEmpty ? review.userName : 'Rabbil Hasan',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (review.rating > 0) RatingStars(rating: review.rating, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(
              color: AppColors.textGrey,
              height: 1.45,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
