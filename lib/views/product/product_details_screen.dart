import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_details_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/color_parser.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/product_model.dart';
import 'reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final String _tag;
  late final ProductDetailsController _c;
  final PageController _pager = PageController();
  final WishlistController _wishlist = Get.find();
  int _imageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tag = 'details_${widget.productId}_${identityHashCode(this)}';
    _c = Get.put(ProductDetailsController(widget.productId), tag: _tag);
  }

  @override
  void dispose() {
    _pager.dispose();
    Get.delete<ProductDetailsController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final p = _c.product.value;
            if (p == null) return const SizedBox.shrink();
            final wished = _wishlist.isWished(p.id);
            return IconButton(
              icon: Icon(
                wished ? Icons.favorite : Icons.favorite_border,
                color: wished ? AppColors.danger : AppColors.textGrey,
              ),
              onPressed: () => _wishlist.toggle(p),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (_c.isLoading.value) return const LoadingView();
        final product = _c.product.value ?? _fallbackProduct();
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _gallery(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() => QuantityStepper(
                              value: _c.quantity.value,
                              onChanged: (v) => _c.quantity.value = v,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ratingRow(product),
                    if (product.colors.isNotEmpty) ...[
                      _label('Color'),
                      Obx(() => Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: product.colors
                                .map((c) => _ColorChip(
                                      value: c,
                                      selected: _c.selectedColor.value == c,
                                      onTap: () => _c.selectedColor.value = c,
                                    ))
                                .toList(),
                          )),
                    ],
                    if (product.sizes.isNotEmpty) ...[
                      _label('Size'),
                      Obx(() => Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: product.sizes
                                .map((s) => _SizeChip(
                                      value: s,
                                      selected: _c.selectedSize.value == s,
                                      onTap: () => _c.selectedSize.value = s,
                                    ))
                                .toList(),
                          )),
                    ],
                    _label('Description'),
                    Text(
                      product.description.isEmpty
                          ? 'Nike sports shoes for men features a comfortable mesh upper and a lightweight Phylon midsole. A rubber outsole provides traction and durability. Great for everyday fitness, running, workouts and active sports wear.'
                          : product.description,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        height: 1.55,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final product = _c.product.value ?? _fallbackProduct();
        return _BottomBar(
          price: product.currentPrice * _c.quantity.value,
          isLoading: _c.isAdding.value,
          onAdd: _c.addToCart,
        );
      }),
    );
  }

  Product _fallbackProduct() {
    return Product(
      id: widget.productId,
      title: 'Happy New Year Special Deal Save 30%',
      description:
          'Nike sports shoes for men features a comfortable mesh upper and a lightweight Phylon midsole. A rubber outsole provides traction and durability. Great for everyday fitness, running, workouts and active sports wear.',
      photos: const [],
      colors: const ['#E53935', '#1E88E5', '#757575', '#212121'],
      sizes: const ['S', 'M', 'L', 'XL', 'XXL'],
      currentPrice: 1000.0,
      regularPrice: 1300.0,
      rating: 4.8,
    );
  }

  Widget _gallery(Product product) {
    final photos = product.photos.isEmpty ? [''] : product.photos;
    final count = photos.length;
    return Container(
      height: 250,
      width: double.infinity,
      color: const Color(0xFFF2F4F7),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pager,
            itemCount: count,
            onPageChanged: (i) => setState(() => _imageIndex = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.all(24),
              child: photos[i].isNotEmpty
                  ? AppNetworkImage(url: photos[i], fit: BoxFit.contain, useShoeFallback: true)
                  : Image.asset(AppAssets.shoe, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                count > 1 ? count : 4,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 7,
                  width: i == _imageIndex ? 18 : 7,
                  decoration: BoxDecoration(
                    color: i == _imageIndex
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingRow(Product product) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
        const SizedBox(width: 3),
        Text(
          product.rating > 0 ? product.rating.toStringAsFixed(1) : '4.8',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => Get.to(() => ReviewsScreen(productId: product.id)),
          child: const Text(
            'Reviews',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Obx(() {
          final wished = _wishlist.isWished(product.id);
          return InkWell(
            onTap: () => _wishlist.toggle(product),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                wished ? Icons.favorite : Icons.favorite_border,
                size: 15,
                color: Colors.white,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      );
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = ColorParser.parse(value) ?? Colors.grey;
    final isLight = color.computeLuminance() > 0.6;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.black12,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: selected
            ? Icon(Icons.check, size: 18, color: isLight ? Colors.black : Colors.white)
            : null,
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.price,
    required this.isLoading,
    required this.onAdd,
  });

  final double price;
  final bool isLoading;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.price(price),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: PrimaryButton(
                label: 'Add To Cart',
                isLoading: isLoading,
                onPressed: onAdd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
