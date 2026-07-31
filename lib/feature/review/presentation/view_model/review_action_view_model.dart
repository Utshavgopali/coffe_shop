import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/delete_review_usecase.dart';
import '../../domain/usecases/submit_review_usecase.dart';
import '../providers/reviews_for_bean_provider.dart';
import '../state/review_action_state.dart';

final reviewActionViewModelProvider =
    NotifierProvider<ReviewActionViewModel, ReviewActionState>(
  ReviewActionViewModel.new,
);

class ReviewActionViewModel extends Notifier<ReviewActionState> {
  late SubmitReviewUsecase _submitReviewUsecase;
  late DeleteReviewUsecase _deleteReviewUsecase;

  @override
  ReviewActionState build() {
    _submitReviewUsecase = ref.read(submitReviewUsecaseProvider);
    _deleteReviewUsecase = ref.read(deleteReviewUsecaseProvider);
    return const ReviewActionState();
  }

  Future<bool> submitReview({
    required String beanId,
    required int rating,
    required String comment,
  }) async {
    state = state.copyWith(status: ReviewActionStatus.submitting, errorMessage: null);

    final result = await _submitReviewUsecase(
      SubmitReviewParams(beanId: beanId, rating: rating, comment: comment),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(status: ReviewActionStatus.error, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(status: ReviewActionStatus.success);
        ref.invalidate(reviewsForBeanProvider(beanId));
        ref.invalidate(myReviewProvider(beanId));
        return true;
      },
    );
  }

  Future<bool> removeReview(String beanId) async {
    state = state.copyWith(status: ReviewActionStatus.submitting, errorMessage: null);

    final result = await _deleteReviewUsecase(beanId);

    return result.fold(
      (failure) {
        state = state.copyWith(status: ReviewActionStatus.error, errorMessage: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(status: ReviewActionStatus.success);
        ref.invalidate(reviewsForBeanProvider(beanId));
        ref.invalidate(myReviewProvider(beanId));
        return true;
      },
    );
  }

  void resetState() {
    state = const ReviewActionState();
  }
}
