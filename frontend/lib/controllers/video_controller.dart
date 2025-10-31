import 'dart:developer';

import 'package:frontend/models/single_video_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/video_model.dart';
import 'package:frontend/services/video_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/comments_model.dart';
import '../services/storage_service.dart';

class VideoController extends GetxController {
  final VideoService _videoService = VideoService();
  final StorageService storageService = StorageService();
  var userId;
  List<VideoModel> videosData = [];
  var singleVideoData = Rxn<SingleVideoModel>();
  List<CommentsModel> commentsData = [];
  List<UsersModel> allUsersData = [];
  List<CommentsWithUserName> commentsWithUserName = [];
  var isLoading = false.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    userId = await storageService.getId();
    log(userId);
  }

  Future<List<VideoModel>> getAllVideosData() async {
    try {
      isLoading.value = true;
      videosData = await _videoService.getAllVideosData();
      return videosData;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVideoData(String videoId) async {
    try {
      isLoading.value = true;
      singleVideoData.value = await _videoService.getVideoData(videoId, userId);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> incrementViewAndFetchVideoData(String videoId) async {
    try {
      isLoading.value = true;
      singleVideoData.value = await _videoService.incrementViewAndFetchVideoData(videoId, userId);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeVideo(String videoId) async {
    try {
      isLoading.value = true;
      singleVideoData.value = await _videoService.likeVideo(videoId, userId);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getComments(String videoId) async {
    try {
      isLoading.value = true;
      commentsData = await _videoService.getCommentsData(videoId);
      await getAllUsers();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllUsers() async {
    try {
      allUsersData = await _videoService.getAllUsersData();
      commentWithUser();
    } catch (e) {
      rethrow;
    }
  }

  void commentWithUser() {
    final Map<String, String> userIdToName = {for (var u in allUsersData) u.id: u.username};

    /// Attach username to each comment
    final List<CommentsWithUserName> combined = commentsData.map((c) {
      return CommentsWithUserName(
        userId: c.userId,
        username: userIdToName[c.userId]!,
        comment: c.comment,
        dateTime: formatTime(c.dateTime),
      );
    }).toList();

    commentsWithUserName = combined;
  }

  String formatTime(String timestamp) {
    try {
      // Parse backend datetime
      final DateTime dateTime = DateTime.parse(timestamp);

      // Format to hh:mm a (e.g., 12:16 PM)
      final String formatted = DateFormat('hh:mm a').format(dateTime);

      return formatted;
    } catch (e) {
      print('Error formatting time: $e');
      return '';
    }
  }

  Future<void> commentVideo(String videoId, String comment) async {
    try {
      isLoading.value = true;
      commentsData = await _videoService.commentVideo(videoId, userId, comment);
      await getAllUsers();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
