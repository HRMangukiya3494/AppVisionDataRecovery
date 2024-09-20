import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_recovery/controller/ScannerController.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/screens/ScannedPage.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_recovery/views/utils/GIFUtils.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';

import '../utils/ColorUtils.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final ScannerController controller = Get.put(ScannerController());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 10, end: 90).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
    // Start the animation if isScanning is true
    controller.isScanning.listen((isScanning) {
      if (isScanning) {
        print("Scanning");
        _controller.forward();
      } else {
        print("Stop called");
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Start Scanning",
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
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    PngImages.PNGPath + PngImages.ScanningVetctor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Obx(
              () => Container(
                height: h * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: ColorUtils.mainGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(h * 0.02),
                    topRight: Radius.circular(h * 0.02),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(h * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.total} Files Found",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: h * 0.028,
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      for (var rowData in controller.rowsData)
                        Container(
                          margin: EdgeInsets.only(bottom: h * 0.02),
                          child: Row(
                            children: [
                              Container(
                                height: h * 0.04,
                                width: w * 0.1,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(rowData['iconPath']),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          rowData['title'],
                                          style: TextStyle(
                                            fontSize: h * 0.02,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "${rowData['count']}",
                                          style: TextStyle(
                                            fontSize: h * 0.02,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: h * 0.01),
                                    // Obx(() {return
                                    AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        return LinearProgressIndicator(
                                          value: controller.isScanning.value
                                              ? _animation.value / 100.0
                                              : (rowData['total'] != 0
                                                  ? rowData['count'] /
                                                      rowData['total']
                                                  : 0.0),
                                          color: const Color(0xffFEBA0B),
                                          backgroundColor:
                                              Colors.white.withOpacity(0.2),
                                        );
                                      },
                                    )
                                    // }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ScannedPage(), arguments: {
                            'images': controller.images,
                            'videos': controller.videos,
                            'audios': controller.audios,
                            'documents': controller.documents,
                          });
                        },
                        child: Container(
                          height: h * 0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffFEBA0B),
                            borderRadius: BorderRadius.circular(
                              h * 0.01,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Scan Successful",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: h * 0.024,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
