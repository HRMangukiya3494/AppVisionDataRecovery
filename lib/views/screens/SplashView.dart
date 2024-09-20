import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:get/get.dart';

import '../utils/ColorUtils.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    Future.delayed(Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.HOMESCREEN);
    });
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: ColorUtils.mainGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    PngImages.PNGPath + PngImages.SplashVector,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.1,
            ),
            Text(
              "Data Recovery",
              style: TextStyle(
                fontSize: h * 0.034,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Text(
              "Recover All Data\nQuickly And Easily.",
              style: TextStyle(
                fontSize: h * 0.026,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: h * 0.04,
            ),
            CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
