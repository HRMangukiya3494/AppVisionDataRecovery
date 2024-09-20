import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/DetailImageController.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';

class DetailImagesPage extends StatelessWidget {
  const DetailImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final controller = Get.put(
      DetailImageController(),
    );

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
                padding: EdgeInsets.all(h * 0.02),
                child: Row(
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
                      "Images",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h * 0.024,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.downloadImage();
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
                            Icons.download,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                height: h * 0.84,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Obx(() {
                      return Container(
                        height: h * 0.74,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(controller
                                .imagePaths[controller.currentIndex.value])),
                            fit: BoxFit.contain,
                          ),
                          color: Colors.grey,
                        ),
                      );
                    }),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(h * 0.01),
                        child: Obx(() {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.imagePaths.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  controller.currentIndex.value = index;
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: w * 0.02),
                                  height: h * 0.08,
                                  width: h * 0.08,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                          File(controller.imagePaths[index])),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
