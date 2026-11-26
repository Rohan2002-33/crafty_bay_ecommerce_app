import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.radius = 0,
    this.iconSize = 30,
    this.useShoeFallback = true,
  });

  final String url;
  final BoxFit fit;
  final double radius;
  final double iconSize;
  final bool useShoeFallback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty || !url.startsWith('http')
          ? _fallback()
          : CachedNetworkImage(
              imageUrl: url,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
              placeholder: (_, _) => _placeholder(),
              errorWidget: (_, _, _) => _fallback(),
            ),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      );

  Widget _fallback() {
    if (useShoeFallback) {
      return Container(
        color: AppColors.primaryLight.withValues(alpha: 0.6),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          AppAssets.shoe,
          fit: fit,
          errorBuilder: (_, _, _) => _iconPlaceholder(),
        ),
      );
    }
    return _iconPlaceholder();
  }

  Widget _iconPlaceholder() => Container(
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: iconSize,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      );
}
