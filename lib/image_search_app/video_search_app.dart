import 'dart:convert';
import 'package:carousel_slider/carousel_options.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:newtest/image_search_app/model_data/json_data.dart';

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController video_controller;

  const VideoPlayerWidget({
    Key? key,
    required this.video_controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      video_controller != null && video_controller.value.isInitialized
          ? Container(
              alignment: Alignment.topCenter,
              child: buildVideo(),
            )
          : Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(
              child: BasicOverlayWeight(video_controller: video_controller)),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
      aspectRatio: video_controller.value.aspectRatio,
      child: VideoPlayer(video_controller));
}

class BasicOverlayWeight extends StatelessWidget {
  final VideoPlayerController video_controller;

  const BasicOverlayWeight({
    Key? key,
    required this.video_controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => video_controller.value.isPlaying
        ? video_controller.pause()
        : video_controller.play(),
    child: Stack(
          children: <Widget>[
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
        video_controller,
        allowScrubbing: true,
      );

  Widget buildPlay() => video_controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
}

class VideoSearchApp extends StatefulWidget {
  const VideoSearchApp({Key? key}) : super(key: key);

  @override
  State<VideoSearchApp> createState() => _VideoSearchAppState();
}

class _VideoSearchAppState extends State<VideoSearchApp> {
  final asset = 'assets/20220720_???????????????.mp4';
  late VideoPlayerController video_controller; // late ?????? ???? ?????????
  // ????????? controller.play ???????????? null ??? ????????? ??? ????????? ????????? ?????????...



  @override
  void initState() {
    super.initState();
    video_controller = VideoPlayerController.network("https://cdn.pixabay.com/vimeo/328940142/Buttercups%20-%2022634.mp4?width=3840&hash=973e1bca2a1cd997686a408cf73a9256ae0a9cad") //.asset(asset) or .file(path)
    // video_controller = VideoPlayerController.asset(asset) // or .file(path)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => video_controller.play());
  }

  @override
  void dispose() {
    video_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = video_controller.value.volume == 0;

    return Scaffold(
      body: Column(
        children: [
          VideoPlayerWidget(video_controller: video_controller),
          const SizedBox(
            height: 32,
          ),
          if (video_controller != null && video_controller.value.isInitialized)
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                  onPressed: () => video_controller.setVolume(isMuted ? 1 : 0),
                  icon: Icon(
                    isMuted ? Icons.volume_mute : Icons.volume_up,
                    color: Colors.white,
                  )),
            )
        ],
      ),
    );
  }

  // ????????? ????????? ?????? ?????? ??????/??????????????? ?????? ??????, ????????????.

  Future<List<JsonData>> getJsonFile(String query) async {
    // await Future.delayed(const Duration(seconds: 2)); // ???????????? ?????????????????? 2??? ??????????????? ??????

    // ?????? ??? ?????? &pretty=true ????????? ??????????????? ??????
    Uri url = Uri.parse(
        'https://pixabay.com/api/videos/?key=28866788-11de021711810cc8df58d08a2&q=$query');

    http.Response response = await http.get(url);
    print('Response status: ${response.statusCode}');
    String jsonString = response.body;

    // String jsonString = images;
    Map<String, dynamic> json = jsonDecode(jsonString);
    Iterable hits = json['hits']['videos']['tiny'];
    // Iterable videos = json['videos'];
    List<JsonData> results = hits.map((e) => JsonData.fromJson(e)).toList();
    return results;

    // throw Exception('????????? ?????? ?????? ?????????'); // ????????? ????????? ?????????????????? return ??? ?????? ??????
    // return []; // data ??? ?????? ????????? ????????? ??? ??????
  }
}
