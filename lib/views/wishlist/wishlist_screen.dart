import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/nav_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/state_views.dart';
import '../shared/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wish List'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (wishlist.isLoading.value && wishlist.items.isEmpty) {
          return const LoadingView();
        }
        if (wishlist.errorMessage.value != null && wishlist.items.isEmpty) {
          return ErrorState(
            message: wishlist.errorMessage.value!,
            onRetry: wishlist.load,
          );
        }
        if (wishlist.items.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border_rounded,
            title: 'Your wish list is empty',
            message: 'Tap the heart on any product to save it here.',
            actionLabel: 'Browse products',
            onAction: () => Get.find<NavController>().change(0),
          );
        }
        return RefreshIndicator(
          onRefresh: wishlist.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(14),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemCount: wishlist.items.length,
            itemBuilder: (_, i) => ProductCard(product: wishlist.items[i].product),
          ),
        );
      }),
    );
  }
}