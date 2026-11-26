import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_list_controller.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/state_views.dart';
import '../../data/data_sources/app_catalog.dart';
import '../../data/models/product_model.dart';
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

  List<Product> _getDemoProducts() {
    final list = AppCatalog.getByCategory(widget.categoryId ?? widget.title);
    return list.isNotEmpty ? list : AppCatalog.products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (_c.isLoading.value && _c.products.isEmpty) return const LoadingView();

        final products = _c.products.isNotEmpty ? _c.products : _getDemoProducts();
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _c.load,
                child: GridView.builder(
                  controller: _scroll,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) => ProductCard(product: products[i]),
                ),
              ),
            ),
            if (_c.isLoadingMore.value) const LinearProgressIndicator(minHeight: 3),
          ],
        );
      }),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1, isChildScreen: true),
    );
  }
}
