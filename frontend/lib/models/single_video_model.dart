class SingleVideoModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String youtubeUrl;
  final int likes;
  final int views;
  final int comments;
  final String thumbnail;
  final String duration;
  final bool isLiked;

  SingleVideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.youtubeUrl,
    required this.likes,
    required this.views,
    required this.comments,
    required this.thumbnail,
    required this.duration,
    required this.isLiked,
  });

  factory SingleVideoModel.fromJson(Map<String, dynamic> json) {
    return SingleVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      youtubeUrl: json['youtube_url'] as String,
      likes: json['likes'] as int,
      views: json['views'] as int,
      comments: json['comments'] as int,
      thumbnail: json['thumbnail'] as String,
      duration: json['duration'] as String,
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'youtube_url': youtubeUrl,
      'likes': likes,
      'views': views,
      'comments': comments,
      'thumbnail': thumbnail,
      'duration': duration,
      'is_liked': isLiked,
    };
  }
}
