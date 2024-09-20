import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/ScannedController.dart';
import 'package:photo_recovery/model/FileModel.dart';

import '../utils/ImageUtils.dart';

class ScannedPage extends StatelessWidget {
  const ScannedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannedPageController controller = Get.put(ScannedPageController());
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final Map<String, dynamic> arguments = Get.arguments;
    controller.setData(
      arguments['images'] ?? [],
      arguments['videos'] ?? [],
      arguments['audios'] ?? [],
      arguments['documents'] ?? [],
    );

    List ScannedList = controller.ScannedList;

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
          "Scanned",
          style: TextStyle(
            color: Colors.white,
            fontSize: h * 0.024,
            fontWeight: FontWeight.w500,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff9099FF),
                Color(0xff4B5DFF),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: h * 0.06,
          ),
          Container(
            height: h * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  PngImages.PNGPath + PngImages.ScannedVector,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              h * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff9099FF),
                  Color(0xff4B5DFF),
                ],
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  h * 0.02,
                ),
                topLeft: Radius.circular(
                  h * 0.02,
                ),
              ),
            ),
            child: Obx(() => Column(
                  children: [
                    for (int i = 0; i < ScannedList.length; i += 2)
                      Row(
                        children: [
                          if (i < ScannedList.length)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _handleOnTap(controller, i);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: h * 0.02,
                                    right: h * 0.01,
                                  ),
                                  height: h * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffE2E5FF),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      h * 0.01,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: h * 0.02),
                                      Container(
                                        height: h * 0.096,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                ScannedList[i]['ImageURL']),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: h * 0.06,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.circular(h * 0.01),
                                            bottomLeft:
                                                Radius.circular(h * 0.01),
                                          ),
                                          color: const Color(0XFFE2E5FF),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ScannedList[i]['Name'],
                                              style: const TextStyle(
                                                  color: Color(0xff4C5DFF)),
                                            ),
                                            Text(
                                              _getCount(controller, i)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (i + 1 < ScannedList.length)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _handleOnTap(controller, i + 1);
                                },
                                child: Container(
                                  height: h * 0.2,
                                  margin: EdgeInsets.only(
                                    left: w * 0.03,
                                    bottom: h * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xffE2E5FF),
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(h * 0.01),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: h * 0.02),
                                      Container(
                                        height: h * 0.096,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                ScannedList[i + 1]['ImageURL']),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: h * 0.06,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.circular(h * 0.01),
                                            bottomLeft:
                                                Radius.circular(h * 0.01),
                                          ),
                                          color: const Color(0XFFE2E5FF),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              ScannedList[i + 1]['Name'],
                                              style: const TextStyle(
                                                  color: Color(0xff4C5DFF)),
                                            ),
                                            Text(
                                              _getCount(controller, i + 1)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void _handleOnTap(ScannedPageController controller, int index) {
    List<FileModel> selectedList;
    switch (index) {
      case 0:
        selectedList = controller.photosList;
        break;
      case 1:
        selectedList = controller.videosList;
        break;
      case 2:
        selectedList = controller.audioList;
        break;
      case 3:
        selectedList = controller.documentList;
        break;
      default:
        selectedList = [];
    }

    log("Navigating to: ${controller.ScannedList[index]['Name']}");
    for (var file in selectedList) {
      log("File path: ${file.path}");
    }

    Get.toNamed(controller.ScannedList[index]['onTap'], arguments: {
      'files': selectedList,
    });
  }

  int _getCount(ScannedPageController controller, int index) {
    switch (index) {
      case 0:
        return controller.photosCount.value;
      case 1:
        return controller.videosCount.value;
      case 2:
        return controller.audioCount.value;
      case 3:
        return controller.documentCount.value;
      default:
        return 0;
    }
  }
}
