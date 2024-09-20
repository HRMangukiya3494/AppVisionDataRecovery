import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:photo_recovery/controller/VideoController.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final VideoController controller = Get.put(VideoController());

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final List<FileModel> videoFiles = Get.arguments['files'] ?? [];
    controller.setVideos(videoFiles);

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
              SizedBox(height: h * 0.04),
              Padding(
                padding: EdgeInsets.only(
                  left: h * 0.02,
                  right: h * 0.02,
                  top: h * 0.02,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                    SizedBox(width: w * 0.26),
                    Text(
                      "Videos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h * 0.024,
                        fontWeight: FontWeight.w500,
                      ),
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
                  padding: EdgeInsets.only(
                    left: h * 0.04,
                    right: h * 0.04,
                    top: h * 0.04,
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (controller.videos.isEmpty) {
                      return _buildNoVideosFound(h);
                    } else {
                      return _buildVideosGrid(controller, h);
                    }
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoVideosFound(double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * 0.26,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageUtils.ImagePath + ImageUtils.NoVideoFound,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            'No Videos Found',
            style: TextStyle(
              fontSize: h * 0.026,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosGrid(VideoController controller, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${controller.videos.length} Videos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: h * 0.026,
          ),
        ),
        SizedBox(height: h * 0.02),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: h * 0.01,
              crossAxisSpacing: h * 0.01,
            ),
            itemCount: controller.videos.length,
            itemBuilder: (context, index) {
              final videoPath = controller.videos[index].path;
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.DETAILVIDEOSPAGE,
                    arguments: {
                      'videoIndex': index,
                      'videoPaths': controller.videos.map((v) => v.path).toList(),
                    },
                  );
                },
                child: FutureBuilder<String?>(
                  future: controller.getThumbnail(videoPath),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(snapshot.data!)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(h * 0.01),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(h * 0.01),
                              child: Container(
                                height: h * 0.04,
                                width: h * 0.04,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF000000).withOpacity(0.5),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          color: Colors.grey,
                          child: const Center(child: Icon(Icons.error)),
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}