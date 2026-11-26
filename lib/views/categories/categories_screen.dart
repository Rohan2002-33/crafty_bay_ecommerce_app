import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../core/widgets/state_views.dart';
import '../shared/category_tile.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (home.isLoading.value && home.categories.isEmpty) {
          return const LoadingView();
        }
        if (home.categories.isEmpty) {
          return ErrorState(
            message: home.errorMessage.value ?? 'No categories available yet.',
            onRetry: home.load,
          );
        }
        return RefreshIndicator(
          onRefresh: home.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: home.categories.length,
            itemBuilder: (_, i) => CategoryTile(category: home.categories[i]),
          ),
        );
      }),
    );
  }
}