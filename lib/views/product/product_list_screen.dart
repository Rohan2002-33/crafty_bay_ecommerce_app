import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_list_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/state_views.dart';
import '../shared/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    required this.title,
    this.categoryId,
    this.tag,
    this.search,
  });

  final String title;
  final String? categoryId;
  final String? tag;
  final String? search;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final String _tag;
  late final ProductListController _c;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tag = 'list_${identityHashCode(this)}';
    _c = Get.put(
      ProductListController(
        categoryId: widget.categoryId,
        tag: widget.tag,
        search: widget.search,
      ),
      tag: _tag,
    );
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
        _c.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    Get.delete<ProductListController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.title)),
      body: Obx(() {
        if (_c.isLoading.value) return const LoadingView();
        if (_c.errorMessage.value != null && _c.products.isEmpty) {
          return ErrorState(message: _c.errorMessage.value!, onRetry: _c.load);
        }
        if (_c.products.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off_rounded,
            title: 'No products found',
            message: 'Try another category or a different search.',
          );
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _c.load,
                child: GridView.builder(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: _c.products.length,
                  itemBuilder: (_, i) => ProductCard(product: _c.products[i]),
                ),
              ),
            ),
            if (_c.isLoadingMore.value) const LinearProgressIndicator(minHeight: 3),
          ],
        );
      }),
    );
  }
}