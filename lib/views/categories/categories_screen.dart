import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/category_model.dart';
import '../shared/category_tile.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  List<CategoryModel> _getDisplayCategories(List<CategoryModel> loaded) {
    if (loaded.length >= 12) return loaded;

    final base = loaded.isNotEmpty
        ? loaded
        : const [
            CategoryModel(id: 'cat_electronics', title: 'Electronics'),
            CategoryModel(id: 'cat_food', title: 'Food'),
            CategoryModel(id: 'cat_fashion', title: 'Fashion'),
            CategoryModel(id: 'cat_furniture', title: 'Furniture'),
          ];

    final list = <CategoryModel>[...base];
    int counter = 1;
    while (list.length < 16) {
      for (final item in base) {
        if (list.length >= 16) break;
        list.add(CategoryModel(
          id: '${item.id}_$counter',
          title: item.title,
          icon: item.icon,
        ));
      }
      counter++;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.find<NavController>().change(0),
        ),
      ),
      body: Obx(() {
        if (home.isLoading.value && home.categories.isEmpty) {
          return const LoadingView();
        }

        final categories = _getDisplayCategories(home.categories);
        return RefreshIndicator(
          onRefresh: home.load,
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 10,
              childAspectRatio: 0.76,
            ),
            itemCount: categories.length,
            itemBuilder: (_, i) => CategoryTile(category: categories[i]),
          ),
        );
      }),
    );
  }
}
