import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_example/main.dart';
import 'package:video_example/widget/orientation/video_player_fullscreen_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class LandscapePlayerPage extends StatefulWidget {
  @override
  _LandscapePlayerPageState createState() => _LandscapePlayerPageState();
}

class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(urlLandscapeVideo)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());

    setLandscape(); //We set the landscape mode
  }

  @override
  void dispose() {
    controller.dispose();
    setAllOrientations();

    super.dispose();
  }

  Future setLandscape() async {
    // hide overlays statusbar
    await SystemChrome.setEnabledSystemUIOverlays(
        []); //Hides the System overlays.Ex. if i play the video we are hiding the taskbar displayed at the top
    await SystemChrome.setPreferredOrientations([
      //We are setting the device orientation to the Landscape mode
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Wakelock
        .enable(); // ;//Makes sure that the device is waked up and it doesen't sleep if we are watching a long video
  }

  Future setAllOrientations() async {
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation
        .values); //When we are disposing off the controller we set the original configurations for the orientations using this

    await Wakelock.disable();//Now device can sleep again
  }

  @override
  Widget build(BuildContext context) =>
      VideoPlayerFullscreenWidget(controller: controller);
}
