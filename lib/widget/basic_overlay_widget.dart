import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(//If I tap on screen i wanna pause and play so we use Gesture Detector
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            controller.value.isPlaying ? controller.pause() : controller.play(),//We pause and play whenever we click on the screen
        child: Stack(
          children: <Widget>[
            buildPlay(),//Used to play and pause
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildIndicator(),
            ),
          ],
        ),
      );

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,//Makes sure you can change position of video later on as well
      );

  Widget buildPlay() => controller.value.isPlaying
      ? Container()//If video is playing i wanna show nothing so i display an empty Container
      : Container(//If video is paused we show an icon ie it is paused
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
        );
}
