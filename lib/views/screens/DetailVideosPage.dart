import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/DetailVideoController.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:video_player/video_player.dart';

class DetailVideosPage extends StatelessWidget {
  const DetailVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailVideoController controller = Get.put(DetailVideoController());
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final arguments = Get.arguments as Map<String, dynamic>;
    List<String> videoPaths = arguments['videoPaths'];
    controller.videoPaths.assignAll(videoPaths);
    controller.currentIndex.value = arguments['videoIndex'];

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
                          "Video Detail",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: h * 0.024,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: controller.downloadVideo,
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
                height: h * 0.74,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(h * 0.02),
                    topRight: Radius.circular(h * 0.02),
                  ),
                  color: Colors.white,
                ),
                child: Obx(() {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: controller.controller.value.isInitialized
                            ? AspectRatio(
                          aspectRatio: controller.controller.value.aspectRatio,
                          child: VideoPlayer(controller.controller),
                        )
                            : const CircularProgressIndicator(),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.togglePlayPause();
                        },
                        child: Container(
                          height: h * 0.07,
                          width: h * 0.07,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: h * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Container(
                height: h * 0.1,
                padding: EdgeInsets.all(h * 0.01),
                color: Colors.white,
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.videoPaths.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.changeVideo(index);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                          height: h * 0.08,
                          width: h * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: controller.thumbnails.containsKey(index) &&
                                controller.thumbnails[index] != null
                                ? DecorationImage(
                              image: FileImage(File(controller.thumbnails[index]!)),
                              fit: BoxFit.cover,
                            )
                                : null,
                            borderRadius: BorderRadius.circular(h * 0.01),
                          ),
                          child: controller.thumbnails.containsKey(index) &&
                              controller.thumbnails[index] == null
                              ? const Center(
                            child: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          )
                              : null,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}