import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/section_header.dart';
import '../../data/models/product_model.dart';
import '../../data/models/slide_model.dart';
import '../product/product_list_screen.dart';
import '../profile/profile_screen.dart';
import '../shared/category_tile.dart';
import '../shared/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final home = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onSheet: (icon, title, msg) => _sheet(context, icon, title, msg)),
            const _SearchBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: home.load,
                child: Obx(() => _content(home)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(HomeController home) {
    if (home.isLoading.value && home.categories.isEmpty && home.popular.isEmpty) {
      return const _HomeSkeleton();
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _HomeBanner(slides: home.slides.toList()),
        SectionHeader(
          title: 'All Categories',
          onSeeAll: () => Get.find<NavController>().change(1),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: home.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) => CategoryTile(category: home.categories[i]),
          ),
        ),
        _ProductSection(title: 'Popular', tag: 'popular', products: home.popular.toList()),
        _ProductSection(title: 'Special', tag: 'special', products: home.special.toList()),
        _ProductSection(title: 'New', tag: 'new', products: home.newest.toList()),
      ],
    );
  }

  void _sheet(BuildContext context, IconData icon, String title, String message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, height: 1.45),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSheet});

  final void Function(IconData, String, String) onSheet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.logoNav,
            height: 32,
            placeholderBuilder: (_) => Image.asset(AppAssets.logoNav, height: 32),
          ),
          const Spacer(),
          _CircleButton(
            icon: Icons.person_outline_rounded,
            onTap: () => Get.to(() => const ProfileScreen()),
          ),
          const SizedBox(width: 8),
          _CircleButton(
            icon: Icons.call_outlined,
            onTap: () => onSheet(
              Icons.support_agent_rounded,
              'Need help?',
              'Our support team is available every day from 9 AM to 9 PM.',
            ),
          ),
          const SizedBox(width: 8),
          _CircleButton(
            icon: Icons.notifications_none_rounded,
            onTap: () => onSheet(
              Icons.notifications_none_rounded,
              'No notifications',
              'You are all caught up. New offers and order updates will appear here.',
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Icon(icon, size: 19, color: AppColors.textDark),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    final query = value.trim();
    if (query.isEmpty) return;
    Get.to(() => ProductListScreen(title: 'Results for "$query"', search: query));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: _search,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF2F4F7),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textGrey, size: 22),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _HomeBanner extends StatefulWidget {
  const _HomeBanner({required this.slides});

  final List<SlideModel> slides;

  @override
  State<_HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<_HomeBanner> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    final count = slides.isEmpty ? 1 : slides.length;
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: count,
          itemBuilder: (_, i, _) => slides.isEmpty
              ? const _DefaultBanner()
              : _SlideBanner(slide: slides[i]),
          options: CarouselOptions(
            height: 145,
            viewportFraction: 0.92,
            autoPlay: count > 1,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (i, _) => setState(() => _current = i),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 7,
              width: i == _current ? 18 : 7,
              decoration: BoxDecoration(
                color: i == _current
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DefaultBanner extends StatelessWidget {
  const _DefaultBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(AppAssets.shoe, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Happy New Year\nSpecial Deal\nSave 30%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => Get.to(
                      () => const ProductListScreen(
                        title: 'Special Deals',
                        tag: 'special',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideBanner extends StatelessWidget {
  const _SlideBanner({required this.slide});

  final SlideModel slide;

  @override
  Widget build(BuildContext context) {
    if (slide.photoUrl.isEmpty) {
      return const _DefaultBanner();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: slide.photoUrl, fit: BoxFit.cover),
            if (slide.description.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                  child: Text(
                    slide.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection({
    required this.title,
    required this.tag,
    required this.products,
  });

  final String title;
  final String tag;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          onSeeAll: () => Get.to(() => ProductListScreen(title: title, tag: tag)),
        ),
        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) => ProductCard(product: products[i], width: 120),
          ),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget box(double h, {double? w, double r = 12}) => Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(r),
          ),
        );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        box(145, r: 14),
        const SizedBox(height: 24),
        Row(children: List.generate(4, (_) => Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: box(64),
            )))),
        const SizedBox(height: 24),
        Row(children: List.generate(3, (_) => Expanded(child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: box(160),
            )))),
      ],
    );
  }
}
