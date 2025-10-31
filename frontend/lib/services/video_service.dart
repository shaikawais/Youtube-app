import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/comments_model.dart';
import 'package:frontend/models/single_video_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/video_model.dart';
import 'package:http/http.dart' as http;

import '../utils/app_config.dart';

class VideoService {
  final client = http.Client();

  Future<List<VideoModel>> getAllVideosData() async {
    try {
      final uri = Uri.parse("${AppConfig.activeHost}/videos/all_videos");

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<VideoModel> videosData =
            jsonList.map((json) => VideoModel.fromJson(json as Map<String, dynamic>)).toList();

        return videosData;
      } else {
        throw Exception("Failed to load videos: ${response.statusCode}");
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<SingleVideoModel> getVideoData(String videoId, String userId) async {
    try {
      final uri = Uri.parse("${AppConfig.activeHost}/videos/video").replace(queryParameters: {
        "video_id": videoId,
        "user_id": userId,
      });
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return SingleVideoModel.fromJson(jsonMap);
      } else {
        throw Exception("Failed to load videos: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SingleVideoModel> incrementViewAndFetchVideoData(String videoId, String userId) async {
    try {
      final uri =
          Uri.parse("${AppConfig.activeHost}/interactions/view_video").replace(queryParameters: {
        "video_id": videoId,
        "user_id": userId,
      });
      final response = await client.patch(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final Map<String, dynamic> videoData = jsonMap["video"];
        return SingleVideoModel.fromJson(videoData);
      } else {
        throw Exception("Failed to load videos: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SingleVideoModel> likeVideo(String videoId, String userId) async {
    try {
      log(videoId + ' ' + userId);
      final uri =
          Uri.parse("${AppConfig.activeHost}/interactions/like_video").replace(queryParameters: {
        "video_id": videoId,
        "user_id": userId,
      });
      final response = await client.patch(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final Map<String, dynamic> videoData = jsonMap["video"];
        return SingleVideoModel.fromJson(videoData);
      } else {
        throw Exception("Failed to load videos: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentsModel>> getCommentsData(
    String videoId,
  ) async {
    try {
      final uri =
          Uri.parse("${AppConfig.activeHost}/interactions/get_comments").replace(queryParameters: {
        "video_id": videoId,
      });
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List commentsJson = jsonMap['comments'];
        return commentsJson.map((e) => CommentsModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load comments: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UsersModel>> getAllUsersData() async {
    try {
      final uri = Uri.parse("${AppConfig.activeHost}/auth/get_all_users");

      final response = await client.get(
        uri,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => UsersModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load All Users: ${response.statusCode}");
        ;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<CommentsModel>> commentVideo(String videoId, String userId, String comment) async {
    final response = await http.patch(
      Uri.parse("${AppConfig.activeHost}/interactions/comment_video").replace(queryParameters: {
        "video_id": videoId,
        "user_id": userId,
        "comment": comment,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List comments = data['comments'];
      return comments.map((e) => CommentsModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to add comment');
    }
  }
}
