import 'package:flutter/material.dart';
import 'package:frontend/controllers/video_controller.dart';
import 'package:frontend/models/video_model.dart';
import 'package:frontend/services/storage_service.dart';
import 'package:get/get.dart';

import '../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VideoController videoController = Get.find<VideoController>();
  final StorageService storageService = StorageService();
  List<VideoModel> videosData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    videosData = await videoController.getAllVideosData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () {
            if (videoController.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: videosData.length,
                itemBuilder: (context, index) {
                  final video = videosData[index];
                  return VideoCard(video: video);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
