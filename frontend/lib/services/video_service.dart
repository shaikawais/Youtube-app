import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/single_video_model.dart';
import 'package:frontend/models/video_model.dart';
import 'package:http/http.dart' as http;

class VideoService {
  final client = http.Client();

  Future<List<VideoModel>> getAllVideosData() async {
    try {
      final uri = Uri.parse("http://10.0.2.2:9000/videos/all_videos");

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
      final uri = Uri.parse("http://10.0.2.2:9000/videos/video").replace(queryParameters: {
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
          Uri.parse("http://10.0.2.2:9000/interactions/view_video").replace(queryParameters: {
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
          Uri.parse("http://10.0.2.2:9000/interactions/like_video").replace(queryParameters: {
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
}
