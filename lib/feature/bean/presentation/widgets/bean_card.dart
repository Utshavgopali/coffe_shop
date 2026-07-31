import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../wishlist/presentation/view_model/wishlist_view_model.dart';
import '../../domain/entities/bean_entity.dart';

class BeanCard extends ConsumerWidget {
  final BeanEntity bean;
  final VoidCallback? onTap;

  const BeanCard({super.key, required this.bean, this.onTap});

  String? get _imageUrl =>
      bean.images.isNotEmpty ? ApiEndpoints.resolveImageUrl(bean.images.first) : null;

  String _roastLabel(String roastLevel, AppLanguage lang) {
    switch (roastLevel) {
      case 'light':
        return AppStrings.get('roastLightFull', lang);
      case 'medium':
        return AppStrings.get('roastMediumFull', lang);
      case 'medium-dark':
        return AppStrings.get('roastMediumDarkFull', lang);
      case 'dark':
        return AppStrings.get('roastDarkFull', lang);
      default:
        return roastLevel;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final isWishlisted = wishlistState.isWishlisted(bean.id);
    final lang = ref.watch(localeViewModelProvider).language;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholderImage(),
                          errorWidget: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () async {
                      final success = await ref
                          .read(wishlistViewModelProvider.notifier)
                          .toggleWishlist(bean);

                      if (!success && context.mounted) {
                        final errorMessage =
                            ref.read(wishlistViewModelProvider).errorMessage;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage ?? AppStrings.get('couldNotUpdateWishlist', lang))),
                        );
                      }
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 11,
                        color: const Color(0xFFA32D2D),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bean.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: context.appTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.public, size: 10, color: context.appTextSecondary),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          bean.origin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: context.appTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _roastLabel(bean.roastLevel, lang),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Rs. ${bean.price.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!bean.inStock) ...[
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.get('outOfStock', lang),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 76,
      height: 76,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Icon(Icons.coffee, size: 28, color: AppColors.primary),
    );
  }
}
