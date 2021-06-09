import 'package:flutter/material.dart';
import 'package:video_example/widget/basic_overlay_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.initialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(//Show an indicator if the video isn't loaded
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(child: BasicOverlayWidget(controller: controller)),//Using Basic Overlay Widget we are showing how much of the video has played
                            //BasicOverlayWidget is user created widget       
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: controller.value.aspectRatio,//Basically we give it the aspect ratio else it assumes the aspect ratio on its own.So using this we use the aspect ratio of the video
        child: VideoPlayer(controller),
      );
}
