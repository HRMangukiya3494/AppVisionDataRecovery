import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/AudioController.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';

class DetailAudiosPage extends StatelessWidget {
  const DetailAudiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final AudioController audioController = Get.put(AudioController());
    final Map<String, dynamic> arguments = Get.arguments;

    if (arguments['audioFiles'] == null) {
      return const Scaffold(
        body: Center(
          child: Text('No audio files found.'),
        ),
      );
    }

    final List<FileModel> audioFiles = arguments['audioFiles'];
    final int currentIndex = arguments['currentIndex'];

    audioController.setAudioFiles(audioFiles);
    audioController.playAudio(currentIndex, audioFiles[currentIndex].path);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageUtils.ImagePath + ImageUtils.ImagesPageBG,
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(h * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.04),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: h * 0.05,
                            width: h * 0.05,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFFFFFF).withOpacity(0.2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Music",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: h * 0.024,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: audioController.downloadAudio,
                          child: Container(
                            height: h * 0.05,
                            width: h * 0.05,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFFFFFF).withOpacity(0.2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                height: h * 0.84,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(h * 0.02),
                    topRight: Radius.circular(h * 0.02),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(h * 0.02),
                  child: Obx(() {
                    final currentItem = audioController.audioFiles[audioController.currentIndex.value];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: h * 0.4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                ImageUtils.ImagePath + ImageUtils.AudioIcon2,
                              ),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.04),
                        Text(
                          currentItem.name,
                          style: TextStyle(
                            fontSize: h * 0.026,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: h * 0.04),
                        Obx(() {
                          final position = audioController.currentPosition.value;
                          final duration = audioController.totalDuration.value;
                          return Column(
                            children: [
                              LinearProgressIndicator(
                                value: duration.inSeconds == 0
                                    ? 0
                                    : position.inSeconds / duration.inSeconds,
                                backgroundColor: const Color(0xffE79D03).withOpacity(0.2),
                                color: const Color(0xffFEBA0B),
                              ),
                              SizedBox(height: h * 0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDuration(position),
                                    style: TextStyle(
                                      fontSize: h * 0.016,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    formatDuration(duration),
                                    style: TextStyle(
                                      fontSize: h * 0.016,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: h * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: audioController.playPrevious,
                              child: Container(
                                height: h * 0.06,
                                width: h * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffFFBB0B).withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.skip_previous,
                                    size: h * 0.04,
                                    color: const Color(0xffFFBB0B),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (audioController.isPlaying.value) {
                                  audioController.pauseAudio();
                                } else {
                                  audioController.resumeAudio();
                                }
                              },
                              child: Container(
                                height: h * 0.1,
                                width: h * 0.1,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffFFBB0B),
                                      Color(0xffE09400),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    audioController.isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: h * 0.06,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: audioController.playNext,
                              child: Container(
                                height: h * 0.06,
                                width: h * 0.06,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffFFBB0B).withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.skip_next,
                                    size: h * 0.04,
                                    color: const Color(0xffFFBB0B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
