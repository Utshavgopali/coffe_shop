import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../cart/presentation/view_model/cart_view_model.dart';
import '../../../review/presentation/widgets/review_section.dart';
import '../../../wishlist/presentation/view_model/wishlist_view_model.dart';
import '../../domain/entities/bean_entity.dart';
import '../providers/bean_detail_provider.dart';

class BeanDetailPage extends ConsumerWidget {
  final String beanId;

  const BeanDetailPage({super.key, required this.beanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beanAsync = ref.watch(beanDetailProvider(beanId));
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: beanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 40, color: AppColors.error),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Montserrat'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(beanDetailProvider(beanId)),
                  child: Text(AppStrings.get('retry', lang)),
                ),
              ],
            ),
          ),
        ),
        data: (bean) => _BeanDetailBody(bean: bean),
      ),
    );
  }
}

class _BeanDetailBody extends ConsumerStatefulWidget {
  final BeanEntity bean;

  const _BeanDetailBody({required this.bean});

  @override
  ConsumerState<_BeanDetailBody> createState() => _BeanDetailBodyState();
}

class _BeanDetailBodyState extends ConsumerState<_BeanDetailBody> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  BeanEntity get bean => widget.bean;

  Future<void> _addToCart() async {
    setState(() => _isAddingToCart = true);

    final lang = ref.read(localeViewModelProvider).language;
    final success =
        await ref.read(cartViewModelProvider.notifier).addToCart(bean.id, quantity: _quantity);

    if (!mounted) return;
    setState(() => _isAddingToCart = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppStrings.get('addedToCart', lang)} $_quantity × ${bean.name} ${AppStrings.get('toCart', lang)}',
          ),
        ),
      );
    } else {
      final error = ref.read(cartViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? AppStrings.get('couldNotAddToCart', lang))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final isWishlisted = wishlistState.isWishlisted(bean.id);
    final lang = ref.watch(localeViewModelProvider).language;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: AppColors.primaryDark, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFA32D2D),
                  size: 18,
                ),
              ),
              onPressed: () async {
                final success =
                    await ref.read(wishlistViewModelProvider.notifier).toggleWishlist(bean);
                if (!success && context.mounted) {
                  final error = ref.read(wishlistViewModelProvider).errorMessage;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error ?? AppStrings.get('couldNotUpdateWishlist', lang))),
                  );
                }
              },
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: bean.images.isNotEmpty
                ? PageView.builder(
                    itemCount: bean.images.length,
                    itemBuilder: (_, i) {
                      final url = ApiEndpoints.resolveImageUrl(bean.images[i]);
                      return CachedNetworkImage(
                        imageUrl: url ?? '',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholder(),
                        errorWidget: (_, __, ___) => _placeholder(),
                      );
                    },
                  )
                : _placeholder(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        bean.name,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    Text(
                      'Rs. ${bean.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.public, size: 14, color: context.appTextSecondary),
                    const SizedBox(width: 4),
                    Text(
                      bean.origin,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        color: context.appTextSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${bean.weightGrams}g',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        color: context.appTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(label: _roastLabel(bean.roastLevel, lang)),
                    _Chip(label: _processLabel(bean.process, lang)),
                    _Chip(label: _categoryLabel(bean.category, lang)),
                    if (!bean.inStock) _Chip(label: AppStrings.get('outOfStock', lang), isWarning: true),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: context.appBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          ),
                          SizedBox(
                            width: 24,
                            child: Text(
                              '$_quantity',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: bean.inStock && _quantity < bean.stock
                                ? () => setState(() => _quantity++)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: bean.inStock && !_isAddingToCart ? _addToCart : null,
                          icon: _isAddingToCart
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.shopping_cart_outlined, size: 18),
                          label: Text(
                            bean.inStock ? AppStrings.get('addToCart', lang) : AppStrings.get('outOfStock', lang),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (bean.tastingNotes.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.get('tastingNotes', lang),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: bean.tastingNotes
                        .map((note) => _Chip(label: note, filled: false))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  AppStrings.get('description', lang),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bean.description,
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 28),
                ReviewSection(beanId: bean.id),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.15),
      child: const Center(child: Icon(Icons.coffee, size: 64, color: AppColors.primary)),
    );
  }

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

  String _processLabel(String process, AppLanguage lang) {
    switch (process) {
      case 'washed':
        return AppStrings.get('processWashed', lang);
      case 'natural':
        return AppStrings.get('processNatural', lang);
      case 'honey':
        return AppStrings.get('processHoney', lang);
      case 'anaerobic':
        return AppStrings.get('processAnaerobic', lang);
      default:
        return process;
    }
  }

  String _categoryLabel(String category, AppLanguage lang) {
    switch (category) {
      case 'single-origin':
        return AppStrings.get('categorySingleOrigin', lang);
      case 'blend':
        return AppStrings.get('categoryBlend', lang);
      case 'decaf':
        return AppStrings.get('categoryDecaf', lang);
      case 'espresso':
        return AppStrings.get('categoryEspresso', lang);
      default:
        return category;
    }
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool filled;
  final bool isWarning;

  const _Chip({required this.label, this.filled = true, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? AppColors.error : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? color.withValues(alpha: 0.1) : context.appSurface,
        border: filled ? null : Border.all(color: context.appBorder),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: filled ? color : context.appTextPrimary,
        ),
      ),
    );
  }
}
