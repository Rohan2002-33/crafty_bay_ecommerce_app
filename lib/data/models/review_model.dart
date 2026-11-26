import '../../core/utils/json_helper.dart';

class Review {
  const Review({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  final String id;
  final String userName;
  final String comment;
  final double rating;
  final String createdAt;

  factory Review.fromJson(Map<String, dynamic> j) {
    var name = Json.str(j['user_name'], 'Anonymous');
    final user = j['user'];
    if (user is Map) {
      final full =
          '${Json.str(user['first_name'])} ${Json.str(user['last_name'])}'.trim();
      if (full.isNotEmpty) name = full;
    }
    return Review(
      id: Json.id(j),
      userName: name,
      comment: Json.str(j['comment']),
      rating: Json.dbl(j['rating']),
      createdAt: Json.str(j['createdAt'] ?? j['created_at']),
    );
  }
}