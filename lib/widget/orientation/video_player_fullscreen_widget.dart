import 'package:flutter/material.dart';
import 'package:video_example/widget/basic_overlay_widget.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerFullscreenWidget extends StatelessWidget {
  //We can switch b/w portrait and landscape mode using this
  final VideoPlayerController controller;

  const VideoPlayerFullscreenWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.initialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Center(child: CircularProgressIndicator());

  Widget buildVideo() => Stack(
        fit: StackFit.expand,//Basically it makes the video take the whole width kind of expands it
        children: <Widget>[
          buildVideoPlayer(),
          BasicOverlayWidget(controller: controller),
        ],
      );

  Widget buildVideoPlayer() => buildFullScreen(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = controller.value.size;
    final width = size?.width ?? 0;
    final height = size?.height ?? 0;

    return FittedBox(//Using this we are making sure our video shows in the correct dimensions.No extra stretching and all
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
