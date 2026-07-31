import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_strings.dart';
import '../../../../app/locale/locale_state.dart';
import '../../../../app/locale/locale_view_model.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../../domain/entities/review_entity.dart';
import '../providers/reviews_for_bean_provider.dart';
import '../state/review_action_state.dart';
import '../view_model/review_action_view_model.dart';

class ReviewSection extends ConsumerWidget {
  final String beanId;

  const ReviewSection({super.key, required this.beanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsForBeanProvider(beanId));
    final isLoggedIn = ref.watch(authViewModelProvider).user != null;
    final myReviewAsync = isLoggedIn ? ref.watch(myReviewProvider(beanId)) : null;
    final lang = ref.watch(localeViewModelProvider).language;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.get('reviews', lang),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            if (isLoggedIn)
              TextButton(
                onPressed: () => _openReviewSheet(
                  context,
                  ref,
                  myReviewAsync?.valueOrNull,
                ),
                child: Text(
                  myReviewAsync?.valueOrNull != null
                      ? AppStrings.get('editYourReview', lang)
                      : AppStrings.get('writeAReview', lang),
                  style: const TextStyle(fontFamily: 'Montserrat', color: AppColors.primary),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        reviewsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              AppStrings.get('couldNotLoadReviews', lang),
              style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
            ),
          ),
          data: (result) => _ReviewList(
            beanId: beanId,
            summary: result.summary,
            reviews: result.reviews,
            currentUserId: ref.read(authViewModelProvider).user?.id,
            lang: lang,
          ),
        ),
      ],
    );
  }

  void _openReviewSheet(BuildContext context, WidgetRef ref, ReviewEntity? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _WriteReviewSheet(beanId: beanId, existing: existing),
    );
  }
}

class _ReviewList extends StatelessWidget {
  final String beanId;
  final ReviewSummaryEntity summary;
  final List<ReviewEntity> reviews;
  final String? currentUserId;
  final AppLanguage lang;

  const _ReviewList({
    required this.beanId,
    required this.summary,
    required this.reviews,
    required this.currentUserId,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final reviewWord = AppStrings.get(summary.count == 1 ? 'review' : 'reviews', lang);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              summary.average.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Stars(rating: summary.average, size: 16),
                  const SizedBox(height: 2),
                  Text(
                    '${summary.count} $reviewWord',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: context.appTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppStrings.get('noReviewsYet', lang),
              style: TextStyle(fontFamily: 'Montserrat', color: context.appTextSecondary),
            ),
          )
        else
          ...reviews.map((review) => _ReviewTile(
                beanId: beanId,
                review: review,
                isMine: review.userId == currentUserId,
                lang: lang,
              )),
      ],
    );
  }
}

class _ReviewTile extends ConsumerWidget {
  final String beanId;
  final ReviewEntity review;
  final bool isMine;
  final AppLanguage lang;

  const _ReviewTile({
    required this.beanId,
    required this.review,
    required this.isMine,
    required this.lang,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = ApiEndpoints.resolveImageUrl(review.userAvatar);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appSurfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, size: 16, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName.isEmpty ? AppStrings.get('coffeeLoverFallback', lang) : review.userName,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _Stars(rating: review.rating.toDouble(), size: 12),
                  ],
                ),
              ),
              if (review.verifiedPurchase)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    AppStrings.get('verified', lang),
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
              if (isMine)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 18, color: context.appTextSecondary),
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await ref.read(reviewActionViewModelProvider.notifier).removeReview(beanId);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'delete', child: Text(AppStrings.get('delete', lang))),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;
  final double size;

  const _Stars({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.round();
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          size: size,
          color: const Color(0xFFFFA726),
        );
      }),
    );
  }
}

class _WriteReviewSheet extends ConsumerStatefulWidget {
  final String beanId;
  final ReviewEntity? existing;

  const _WriteReviewSheet({required this.beanId, this.existing});

  @override
  ConsumerState<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<_WriteReviewSheet> {
  late int _rating;
  late final TextEditingController _commentCtrl;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _commentCtrl = TextEditingController(text: widget.existing?.comment ?? '');
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final lang = ref.read(localeViewModelProvider).language;
    final comment = _commentCtrl.text.trim();
    if (comment.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('pleaseWriteAtLeast3Chars', lang))),
      );
      return;
    }

    final success = await ref.read(reviewActionViewModelProvider.notifier).submitReview(
          beanId: widget.beanId,
          rating: _rating,
          comment: comment,
        );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      final error = ref.read(reviewActionViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? AppStrings.get('failedToSubmitReview', lang))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(reviewActionViewModelProvider);
    final isSubmitting = actionState.status == ReviewActionStatus.submitting;
    final lang = ref.watch(localeViewModelProvider).language;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existing != null
                ? AppStrings.get('editYourReview', lang)
                : AppStrings.get('writeAReview', lang),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final starValue = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = starValue),
                icon: Icon(
                  starValue <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xFFFFA726),
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            maxLines: 4,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: AppStrings.get('shareThoughtsAboutBean', lang),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _submit,
              child: isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(AppStrings.get('submit', lang)),
            ),
          ),
        ],
      ),
    );
  }
}
