import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_network_image.dart';
import '../../data/models/category_model.dart';
import '../product/product_list_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final CategoryModel category;

  IconData _getIconForCategory(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('elect') || lower.contains('tech') || lower.contains('apply')) {
      return Icons.tv_rounded;
    } else if (lower.contains('food') || lower.contains('grocer') || lower.contains('fruit')) {
      return Icons.apple_rounded;
    } else if (lower.contains('fash') || lower.contains('cloth') || lower.contains('wear')) {
      return Icons.diamond_outlined;
    } else if (lower.contains('furn') || lower.contains('bed') || lower.contains('home')) {
      return Icons.bed_rounded;
    } else if (lower.contains('sport') || lower.contains('fit') || lower.contains('gym')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('kid') || lower.contains('toy') || lower.contains('baby')) {
      return Icons.child_friendly_rounded;
    } else if (lower.contains('beauty') || lower.contains('cosmetic')) {
      return Icons.auto_awesome_rounded;
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Get.to(
        () => ProductListScreen(title: category.title, categoryId: category.id),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: category.icon.isNotEmpty && category.icon.startsWith('http')
                ? AppNetworkImage(
                    url: category.icon,
                    fit: BoxFit.contain,
                  )
                : Icon(
                    _getIconForCategory(category.title),
                    size: 32,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              category.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
