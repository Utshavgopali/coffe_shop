import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String beanId;
  final int rating;
  final String comment;
  final bool verifiedPurchase;
  final DateTime? createdAt;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.beanId,
    required this.rating,
    required this.comment,
    required this.verifiedPurchase,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        beanId,
        rating,
        comment,
        verifiedPurchase,
        createdAt,
      ];
}

class ReviewSummaryEntity extends Equatable {
  final double average;
  final int count;
  final Map<String, int> breakdown;

  const ReviewSummaryEntity({
    this.average = 0,
    this.count = 0,
    this.breakdown = const {},
  });

  @override
  List<Object?> get props => [average, count, breakdown];
}

class BeanReviewsResult extends Equatable {
  final List<ReviewEntity> reviews;
  final ReviewSummaryEntity summary;

  const BeanReviewsResult({required this.reviews, required this.summary});

  @override
  List<Object?> get props => [reviews, summary];
}
