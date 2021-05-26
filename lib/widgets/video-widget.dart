import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({Key key, @required this.url})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController videoPlayerController ;
  Future<void> _initializeVideoPlayerFuture;


  _initController(){
    videoPlayerController = new VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }


  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Chewie(
                  key: PageStorageKey(widget.url),
                  controller: ChewieController(
                    videoPlayerController: videoPlayerController,
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    autoInitialize: true,
                    looping: false,
                    autoPlay: false,
                    deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight],
                    deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
                    errorBuilder: (context, errorMessage) {
                      return Center(
                        child: Text(
                          errorMessage+"\n\nPlease restart the app and try again!",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}