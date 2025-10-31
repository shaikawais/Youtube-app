import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/single_video_model.dart';
import 'package:frontend/utils/app_config.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/video_controller.dart';
import '../models/video_model.dart';
import '../widgets/expandable_text.dart';
import '../widgets/show_toast.dart';

class VideoStreamScreen extends StatefulWidget {
  final VideoModel video;
  const VideoStreamScreen({super.key, required this.video});

  @override
  State<VideoStreamScreen> createState() => _VideoStreamScreenState();
}

class _VideoStreamScreenState extends State<VideoStreamScreen> with HelperClass {
  final VideoController videoController = Get.find<VideoController>();
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool isVideoInitialized = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadVideoData(widget.video.id);
      await initializeVideoPlayer(widget.video.id);
    });
  }

  Future<void> loadVideoData(String vidId) async {
    await this.videoController.incrementViewAndFetchVideoData(vidId);
  }

  Future<void> initializeVideoPlayer(String videoId) async {
    final videoUrl = "${AppConfig.activeHost}/videos/stream/$videoId";

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    log(_videoPlayerController.toString());
    await _videoPlayerController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController!.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() {
      isVideoInitialized = true;
    });
  }

  void copyLink(BuildContext context, String textToCopy) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    showSuccess(context, "Link copied to clipboard");
  }

  Future<void> handleChipTap(BuildContext context, String label) async {
    if (videoController.singleVideoData.value == null) return;

    if (label == 'Like') {
      await videoController.likeVideo(videoController.singleVideoData.value!.id);
    } else if (label == 'Copy Link') {
      copyLink(context, videoController.singleVideoData.value!.youtubeUrl);
    }
  }

  Future<void> getCommentsData(String vidId) async {
    await this.videoController.getComments(vidId);
    log(videoController.commentsData.toString());
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text("Youtube"),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (videoController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final videoData = videoController.singleVideoData.value;

            if (videoData == null) {
              return const Center(child: Text('No Data Found'));
            }

            final List<IconData> iconNames = [
              videoData.isLiked ? Icons.thumb_up_sharp : Icons.thumb_up_alt_outlined,
              Icons.share,
              Icons.bookmark_outline,
              Icons.flag_outlined,
              Icons.download_outlined,
              Icons.link_outlined,
              Icons.article_outlined,
            ];

            final List<String> iconTexts = [
              'Like',
              "Share",
              "Save",
              "Report",
              "Download",
              "Copy Link",
              "Transcript",
            ];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: isVideoInitialized
                            ? Chewie(controller: _chewieController!)
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.network(
                                    AppConfig.activeHost + videoData.thumbnail,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  const CircularProgressIndicator(),
                                ],
                              ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            videoData.duration,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: Text(
                      videoData.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(11, 8, 10, 4),
                    child: Text(
                      videoData.views.toString() + ' views',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(11, 4, 10, 4),
                    child: ExpandableText(
                      text: videoData.description,
                      trimLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(
                          AppConfig.activeHost + videoData.thumbnail,
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            'Channel ',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '14.2M',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      trailing: SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.red,
                            backgroundColor: Colors.red,
                            elevation: 2,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(18)),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subscribe',
                                style: const TextStyle(fontSize: 15, color: Colors.white),
                              ),
                              Icon(
                                Icons.notification_add_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: SizedBox(
                      height: 42,
                      child: ListView.builder(
                        itemCount: iconNames.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => handleChipTap(context, iconTexts[index]),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    iconNames[index],
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    index == 0 ? videoData.likes.toString() : iconTexts[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        getCommentsData(videoData.id);
                        _openComments(videoData);
                      },
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Comments',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    videoData.comments.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    AppConfig.activeHost + videoData.thumbnail,
                                  ),
                                ),
                                title: Text('View Comments...'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openComments(SingleVideoModel video) {
    Get.bottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0,
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Obx(
          () {
            var commentsData = videoController.commentsWithUserName;
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    if (videoController.isLoading == true) ...[
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ] else ...[
                      Flexible(
                        child: ListView.builder(
                          itemCount: commentsData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                      AppConfig.activeHost + video.thumbnail,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              commentsData[index].username,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 3,
                                            backgroundColor: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              commentsData[index].dateTime!,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(commentsData[index].comment!),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
                // ===== Fixed Input Bar at Bottom =====
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _commentController,
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            final comment = _commentController.text.trim();
                            if (comment.isEmpty) return;

                            await videoController.commentVideo(video.id, comment);
                            _commentController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.send, size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
