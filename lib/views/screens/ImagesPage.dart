import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:photo_recovery/controller/ImagesController.dart';

import '../utils/ColorUtils.dart';

class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagesController controller = Get.put(ImagesController());
    final List<FileModel> imageFiles = Get.arguments['files'] ?? [];
    controller.setImages(imageFiles);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
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
          "Images",
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
          padding: EdgeInsets.only(
            left: h * 0.04,
            right: h * 0.04,
            top: h * 0.04,
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.images.isEmpty) {
              return _buildNoImagesFound(h);
            } else {
              return _buildImagesGrid(controller, h);
            }
          }),
        ),
      ),
    );
  }

  Widget _buildNoImagesFound(double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: h * 0.26,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageUtils.ImagePath + ImageUtils.NoImageFound,
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            'No Images Found',
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

  Widget _buildImagesGrid(ImagesController controller, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${controller.images.length} Images",
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
            itemCount: controller.images.length,
            itemBuilder: (context, index) {
              String imagePath = controller.images[index].path;
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.DETAILIMAGESPAGE,
                    arguments: {
                      'imageIndex': index,
                      'imagePaths': controller.images
                          .map((e) => e.path)
                          .toList(), // Pass image paths as List<String>
                    },
                  );
                  log("Navigated to detail page for image index: $index");
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(h * 0.01),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
