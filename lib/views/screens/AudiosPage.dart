import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/AudioController.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';

import '../utils/ColorUtils.dart';

class AudiosPage extends StatelessWidget {
  final AudioController audioController = Get.put(AudioController());

  AudiosPage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final List<FileModel> audioFiles = Get.arguments['files'] ?? [];

    audioController.setAudio(audioFiles);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Audios",
          style: TextStyle(
            color: Colors.white,
            fontSize: h * 0.024,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: ColorUtils.mainGradient,
          ),
        ),
      ),
      body: Container(
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
          child: audioFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 0.26,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              ImageUtils.ImagePath + ImageUtils.NoMusicFound,
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Center(
                        child: Text(
                          'No Music Found',
                          style: TextStyle(
                            fontSize: h * 0.026,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${audioFiles.length} Audios",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: h * 0.026,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                    Expanded(
                      child: ListView.builder(
                        itemCount: audioFiles.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: h * 0.09,
                            child: GestureDetector(
                              onTap: () {
                                audioController.setAudioFiles(audioFiles);
                                audioController.playAudio(
                                    index, audioFiles[index].path);
                                Get.toNamed(
                                  AppRoutes.DETAILAUDIOSPAGE,
                                  arguments: {
                                    'audioFiles': audioFiles,
                                    'currentIndex': index,
                                  },
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: h * 0.07,
                                    width: h * 0.07,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(ImageUtils.ImagePath +
                                            ImageUtils.AudioIcon2),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: w * 0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          audioFiles[index].name,
                                          style: TextStyle(
                                            fontSize: h * 0.02,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
