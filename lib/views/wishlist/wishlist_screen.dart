import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/nav_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../data/models/product_model.dart';
import '../../data/models/wishlist_item_model.dart';
import '../shared/product_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  List<WishlistItem> _getDemoItems() {
    return List.generate(
      12,
      (i) => WishlistItem(
        id: 'wish_demo_$i',
        product: Product(
          id: 'demo_shoe_$i',
          title: 'New Year Special Shoe',
          currentPrice: 100.0,
          regularPrice: 150.0,
          rating: 4.8,
          photos: const ['assets/images/shoe.png'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Wish List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.find<NavController>().change(0),
        ),
      ),
      body: Obx(() {
        final items = wishlist.items.isNotEmpty ? wishlist.items : _getDemoItems();
        return RefreshIndicator(
          onRefresh: wishlist.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) => ProductCard(product: items[i].product),
          ),
        );
      }),
    );
  }
}
