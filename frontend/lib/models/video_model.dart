class VideoModel {
  final String id;
  final String title;
  final String thumbnail;
  final String duration;

  VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: json['duration'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'duration': duration,
    };
  }
}
