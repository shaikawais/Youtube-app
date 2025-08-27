import 'dart:developer';

import 'package:frontend/models/single_video_model.dart';
import 'package:frontend/models/video_model.dart';
import 'package:frontend/services/video_service.dart';
import 'package:get/get.dart';

import '../services/storage_service.dart';

class VideoController extends GetxController {
  final VideoService _videoService = VideoService();
  final StorageService storageService = StorageService();
  var userId;
  List<VideoModel> videosData = [];
  var singleVideoData = Rxn<SingleVideoModel>();
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
}
