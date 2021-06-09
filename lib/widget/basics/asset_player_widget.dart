import 'package:flutter/material.dart';
import 'package:video_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class AssetPlayerWidget extends StatefulWidget {
  @override
  _AssetPlayerWidgetState createState() => _AssetPlayerWidgetState();
}

class _AssetPlayerWidgetState extends State<AssetPlayerWidget> {
  final asset = 'assets/video.mp4';//Accesing this from the pubspec.yaml file
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))//Update the video player whenever we are playing
      ..setLooping(true)
      ..initialize().then((_) => controller.play());//initialize makes sure the video is loaded already
      //After initializing the video we wanna play the video using controller.play()
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;

    return Column(
      children: [
        VideoPlayerWidget(controller: controller),
        const SizedBox(height: 32),
        if (controller != null && controller.value.initialized)//We wait till the controller is initialized basically the ..initilize is called on the function above
          CircleAvatar(//We are creating a button for our video player to mute
            radius: 30,
            backgroundColor: Colors.red,
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_mute : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () => controller.setVolume(isMuted ? 1 : 0),
            ),
          )
      ],
    );
  }
}
