import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/HomeController.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:photo_recovery/views/utils/ListUtils.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(
    HomeController(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Hey there!",
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
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: h * 0.16,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    PngImages.PNGPath + PngImages.DrawerVector,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.04,
            ),
            ...DrawerList.map(
              (item) => ListTile(
                leading: Container(
                  height: h * 0.04,
                  width: h * 0.04,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        item['ImageURL'],
                      ),
                    ),
                  ),
                ),
                title: Text(
                  item['Name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: h * 0.02,
                  ),
                ),
                onTap: () => item['onTap'](context),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          h * 0.024,
        ),
        child: Column(
          children: [
            Text(
              "Lost important files? Tap 'Scan' to quickly recover photos, contacts, messages, and more. Restore your precious data with ease!",
              style: TextStyle(
                color: Colors.black,
                fontSize: h * 0.02,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: h * 0.1,
            ),
            Container(
              height: h * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    PngImages.PNGPath + PngImages.HomeVector,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Text(
              "Data Recovery",
              style: TextStyle(
                fontSize: h * 0.034,
                fontWeight: FontWeight.bold,
                color: Color(0xff4952B0),
              ),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Text(
              "Tap scan now to start scanning",
              style: TextStyle(
                fontSize: h * 0.026,
                color: Color(0xff4952B0).withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(
          h * 0.02,
        ),
        child: GestureDetector(
          onTap: () {
            controller.startScanning();
          },
          child: Container(
            height: h * 0.08,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff9099FF),
                  Color(0xff4B5DFF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  h * 0.03,
                ),
                bottomRight: Radius.circular(
                  h * 0.03,
                ),
              ),
            ),
            child: Center(
              child: Obx(
                () {
                  return controller.isScanning.value
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "START SCANNING",
                          style: TextStyle(
                            fontSize: h * 0.026,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
