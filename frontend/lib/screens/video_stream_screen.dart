import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVideoData(widget.video.id);
    });
  }

  Future<void> loadVideoData(String vidId) async {
    await this.videoController.incrementViewAndFetchVideoData(vidId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.network(
                      "http://10.0.2.2:9000${videoData.thumbnail}",
                      height: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                        "http://10.0.2.2:9000${videoData.thumbnail}",
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
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget ActionsChip(BuildContext context, IconData iconData, String label) {
  //   return GestureDetector(
  //     onTap: () => handleChipTap(context, label),
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 5),
  //       padding: EdgeInsets.symmetric(horizontal: 15),
  //       decoration: BoxDecoration(
  //         color: Colors.grey[900],
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(
  //             iconData,
  //             size: 20,
  //             color: Colors.white,
  //           ),
  //           SizedBox(width: 6),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 14,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
