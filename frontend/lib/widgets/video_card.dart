import 'package:flutter/material.dart';
import 'package:frontend/models/video_model.dart';
import 'package:frontend/screens/video_stream_screen.dart';
import 'package:get/get.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  const VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(
              () => VideoStreamScreen(
                video: video,
              ),
            );
          },
          child: Stack(
            children: [
              Image.network(
                "http://10.0.2.2:9000${video.thumbnail}",
                height: 240.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    video.duration,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            leading: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                "http://10.0.2.2:9000${video.thumbnail}",
              ),
            ),
            title: Text(
              video.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Channel Name',
              maxLines: 1,
            ),
            trailing: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
