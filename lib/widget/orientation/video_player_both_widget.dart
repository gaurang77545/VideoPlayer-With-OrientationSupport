import 'dart:async';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:video_example/widget/advanced_overlay_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerBothWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoPlayerBothWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  _VideoPlayerBothWidgetState createState() => _VideoPlayerBothWidgetState();
}

class _VideoPlayerBothWidgetState extends State<VideoPlayerBothWidget> {
  StreamSubscription subscription;
  Orientation target;

  @override
  void initState() {
    super.initState();

    subscription = NativeDeviceOrientationCommunicator()//This is used to enable that we can switch b/w landscape and portrait mode as many times as we want
        .onOrientationChanged(useSensor: true)
        .listen((event) {
      final isPortrait = event == NativeDeviceOrientation.portraitUp;
      final isLandscape = event == NativeDeviceOrientation.landscapeLeft ||
          event == NativeDeviceOrientation.landscapeRight;
      final isTargetPortrait = target == Orientation.portrait;
      final isTargetLandscape = target == Orientation.landscape;

      if (isPortrait && isTargetPortrait || isLandscape && isTargetLandscape) {//If our target orientation which we want and the current orientation of the device is the same we wanna clear stuff so that
      //Next time we wanna switch b/w landscape and portrait we can do it effortelessly
        target = null;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);//Now we can switch again
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void setOrientation(bool isPortrait) {
    if (isPortrait) {
      Wakelock.disable();
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    } else {
      Wakelock.enable();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.controller != null && widget.controller.value.initialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Center(child: CircularProgressIndicator());

  Widget buildVideo() => OrientationBuilder(//Basically tells if the orientation has changed or not
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          setOrientation(isPortrait);

          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,//If it is portrait I wanna expand use StackFit.loose
            children: <Widget>[
              buildVideoPlayer(isPortrait),
              Positioned.fill(
                child: AdvancedOverlayWidget(//We use this widget to created an overlay on top of the video
                  controller: widget.controller,
                  onClickedFullScreen: () {//onClicked Full Screen is basically the function which gets called on clicking the button that looks like []
                    target = isPortrait//When we click on the button we set the target as whatever mode we wanna be in
                        ? Orientation.landscape
                        : Orientation.portrait;

                    if (isPortrait) {//If it is in portrait mode change it to landscape
                      AutoOrientation.landscapeRightMode();
                    } else {
                      AutoOrientation.portraitUpMode();
                    }
                  },
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer(bool isPortrait) {
    final video = AspectRatio(
      aspectRatio: widget.controller.value.aspectRatio,
      child: VideoPlayer(widget.controller),
    );

    if (isPortrait) {
      return video;
    } else {
      return WillPopScope(
        onWillPop: () {
          AutoOrientation.portraitUpMode();
          return Future.value(false);
        },
        child: buildFullScreen(child: video),
      );
    }
  }

  Widget buildFullScreen({
    @required Widget child,
  }) {
    final size = widget.controller.value.size;
    final width = size?.width ?? 0;
    final height = size?.height ?? 0;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
