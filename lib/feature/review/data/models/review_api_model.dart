import '../../domain/entities/review_entity.dart';

class ReviewApiModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String beanId;
  final int rating;
  final String comment;
  final bool verifiedPurchase;
  final DateTime? createdAt;

  const ReviewApiModel({
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

  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    final userField = json['user'];
    String userId = '';
    String userName = '';
    String? userAvatar;

    if (userField is Map) {
      userId = (userField['_id'] ?? userField['id'] ?? '') as String;
      userName = userField['name'] as String? ?? '';
      userAvatar = userField['avatar'] as String?;
    } else if (userField is String) {
      userId = userField;
    }

    return ReviewApiModel(
      id: (json['id'] ?? json['_id']) as String,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      beanId: (json['bean'] is Map
          ? (json['bean']['_id'] ?? json['bean']['id'])
          : json['bean']) as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      verifiedPurchase: json['verifiedPurchase'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      beanId: beanId,
      rating: rating,
      comment: comment,
      verifiedPurchase: verifiedPurchase,
      createdAt: createdAt,
    );
  }
}

class ReviewSummaryApiModel {
  final double average;
  final int count;
  final Map<String, int> breakdown;

  const ReviewSummaryApiModel({
    this.average = 0,
    this.count = 0,
    this.breakdown = const {},
  });

  factory ReviewSummaryApiModel.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json['breakdown'] as Map<String, dynamic>? ?? {};
    return ReviewSummaryApiModel(
      average: (json['average'] as num?)?.toDouble() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      breakdown: rawBreakdown.map((k, v) => MapEntry(k, (v as num).toInt())),
    );
  }

  ReviewSummaryEntity toEntity() {
    return ReviewSummaryEntity(average: average, count: count, breakdown: breakdown);
  }
}
