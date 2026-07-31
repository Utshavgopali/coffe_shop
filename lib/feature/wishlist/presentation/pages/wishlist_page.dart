import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../bean/presentation/pages/bean_detail_page.dart';
import '../state/wishlist_state.dart';
import '../view_model/wishlist_view_model.dart';

class WishlistPage extends ConsumerStatefulWidget {
  const WishlistPage({super.key});

  @override
  ConsumerState<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends ConsumerState<WishlistPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(wishlistViewModelProvider.notifier).loadWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistViewModelProvider);
    final count = wishlistState.items.length;
    final lang = ref.watch(localeViewModelProvider).language;

    return Scaffold(
      backgroundColor: context.appBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get('navWishlist', lang),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, size: 13, color: AppColors.primary),
                        const SizedBox(width: 5),
                        Text(
                          '$count',
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(wishlistViewModelProvider.notifier).loadWishlist(),
                child: _buildBody(wishlistState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(WishlistState state) {
    final lang = ref.read(localeViewModelProvider).language;

    if (state.status == WishlistStatus.loading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state.status == WishlistStatus.error && state.items.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Text(
              state.errorMessage ?? AppStrings.get('somethingWentWrong', lang),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: () => ref.read(wishlistViewModelProvider.notifier).loadWishlist(),
              child: Text(AppStrings.get('retry', lang)),
            ),
          ),
        ],
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border, size: 32, color: context.appTextSecondary),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              AppStrings.get('noFavouritesYet', lang),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppStrings.get('tapHeartToSave', lang),
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: context.appTextSecondary),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        final bean = item.bean;
        final imageUrl =
            bean.images.isNotEmpty ? ApiEndpoints.resolveImageUrl(bean.images.first) : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.appSurface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BeanDetailPage(beanId: bean.id)),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _thumbnailPlaceholder(),
                          errorWidget: (_, __, ___) => _thumbnailPlaceholder(),
                        )
                      : _thumbnailPlaceholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bean.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.appTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bean.origin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 11,
                          color: context.appTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rs. ${bean.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final success =
                        await ref.read(wishlistViewModelProvider.notifier).toggleWishlist(bean);

                    if (!success && context.mounted) {
                      final errorMessage = ref.read(wishlistViewModelProvider).errorMessage;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage ?? AppStrings.get('couldNotRemoveFromWishlist', lang))),
                      );
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDEBEC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, size: 15, color: Color(0xFFA32D2D)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Icon(Icons.coffee, size: 24, color: AppColors.primary),
    );
  }
}
