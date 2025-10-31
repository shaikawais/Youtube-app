class CommentsModel {
  final String userId;
  final String comment;
  final String dateTime;

  CommentsModel({
    required this.userId,
    required this.comment,
    required this.dateTime,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> json) {
    return CommentsModel(
      userId: json['user_id'] as String,
      comment: json['comment'] as String,
      dateTime: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'comment': comment,
      'timestamp': dateTime,
    };
  }
}

class CommentsWithUserName {
  final String? userId;
  final String username;
  final String? comment;
  final String? dateTime;

  CommentsWithUserName({
    required this.userId,
    required this.username,
    this.comment,
    this.dateTime,
  });
}
