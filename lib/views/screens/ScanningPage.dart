import 'dart:math';
import 'package:flutter/material.dart';
import 'package:photo_recovery/controller/ScannerController.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/screens/ScannedPage.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_recovery/views/utils/GIFUtils.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getRandomValue(int min, int max) {
    return (min + (max - min) * (Random().nextDouble())).toDouble();
  }

  void startAnimation() {
    _controller.forward(from: 0.0); // Restart from beginning
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageUtils.ImagePath + ImageUtils.ScanningBG,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: h * 0.16),
            height: h * 0.34,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(GifUtils.SearchScanning),
                fit: BoxFit.cover,
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
                            Get.offAllNamed(AppRoutes.HOMESCREEN);
                          },
                          child: Container(
                            height: h * 0.05,
                            width: h * 0.05,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Center(
                              child:
                                  Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        Text(
                          "Start Scanning",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: h * 0.024,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(() => Container(
                    height: h * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(h * 0.02),
                        topRight: Radius.circular(h * 0.02),
                      ),
                      color: Colors.white,
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
                              color: Colors.black,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              rowData['title'],
                                              style: TextStyle(
                                                fontSize: h * 0.02,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "${rowData['count']}",
                                              style: TextStyle(
                                                fontSize: h * 0.02,
                                                color: Colors.black54,
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
                                                  const Color(0xffE79D03)
                                                      .withOpacity(0.2),
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
                          Obx(() {
                            if (controller.isVideoPlayed.value) {
                              return Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ScannedPage(),
                                        arguments: {
                                          'images': controller.images,
                                          'videos': controller.videos,
                                          'audios': controller.audios,
                                          'documents': controller.documents,
                                        });
                                  },
                                  child: Container(
                                    height: h * 0.06,
                                    width: w * 0.8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(h * 0.012),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/Success.png',
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    child: const Center(
                                      child: SizedBox.expand(),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: controller.isFault.value
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(() => const ScannedPage(),
                                              arguments: {
                                                'images': controller.images,
                                                'videos': controller.videos,
                                                'audios': controller.audios,
                                                'documents':
                                                    controller.documents,
                                              });
                                        },
                                        child: Container(
                                          height: h * 0.06,
                                          width: w * 0.8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                h * 0.012),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/Success.png',
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          child: const Center(
                                            child: SizedBox.expand(),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: h * 0.06,
                                        width: w * 0.8,
                                        child: VideoPlayer(
                                            controller.videoController),
                                      ),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
