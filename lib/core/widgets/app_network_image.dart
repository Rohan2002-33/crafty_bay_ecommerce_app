import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.contain,
    this.radius = 0,
    this.iconSize = 28,
    this.fallbackAsset,
  });

  final String url;
  final BoxFit fit;
  final double radius;
  final double iconSize;
  final String? fallbackAsset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }

    if (url.isEmpty || !url.startsWith('http')) {
      if (fallbackAsset != null) {
        return Image.asset(
          fallbackAsset!,
          fit: fit,
          errorBuilder: (_, _, _) => _placeholder(),
        );
      }
      return _placeholder();
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => _loadingPlaceholder(),
      errorWidget: (_, _, _) => fallbackAsset != null
          ? Image.asset(fallbackAsset!, fit: fit, errorBuilder: (_, _, _) => _placeholder())
          : _placeholder(),
    );
  }

  Widget _loadingPlaceholder() => Container(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      );

  Widget _placeholder() => Container(
        color: AppColors.primaryLight.withValues(alpha: 0.6),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: iconSize,
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
      );
}
