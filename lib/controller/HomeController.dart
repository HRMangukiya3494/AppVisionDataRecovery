import 'dart:developer';
import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/model/FileService.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';

import '../model/FileServiceTest.dart';

class HomeController extends GetxController {
  var isScanning = false.obs;
  var recoveredFiles = <FileModel>[].obs;
  void startScanning() {
    isScanning.value = true;
    // MovetoNewPageAfterScan();
    navigateToScanningPageWithOutValue();
  }

  Future<void> MovetoNewPageAfterScan() async {
    try {
      List<FileModel> files = await FileServiceTest.scanDeletedFiles();
      log('Files found: ${files.length}');
      if (files.isNotEmpty) {
        recoveredFiles.assignAll(files);
        // navigateToScanningPage();
      } else {
        Get.snackbar('No files found', 'Please try again');
      }
    } catch (e) {
      log('Error during scanning: $e');
      Get.snackbar('Error', 'An error occurred during scanning');
    } finally {
      isScanning.value = false;
      //  var images =
      //     recoveredFiles.where((file) => file.type == FileType.image).toList();
      // var videos =
      //     recoveredFiles.where((file) => file.type == FileType.video).toList();
      // var audios =
      //     recoveredFiles.where((file) => file.type == FileType.audio).toList();
      // var documents = recoveredFiles
      //     .where((file) => file.type == FileType.document)
      //     .toList();
    }
  }

  void navigateToScanningPage() {
    var images =
        recoveredFiles.where((file) => file.type == FileType.image).toList();
    var videos =
        recoveredFiles.where((file) => file.type == FileType.video).toList();
    var audios =
        recoveredFiles.where((file) => file.type == FileType.audio).toList();
    var documents =
        recoveredFiles.where((file) => file.type == FileType.document).toList();

    Get.toNamed(AppRoutes.SCANNING, arguments: {
      'images': images,
      'videos': videos,
      'audios': audios,
      'documents': documents,
    });
  }

  void navigateToScanningPageWithOutValue() {
    // var images =
    //     recoveredFiles.where((file) => file.type == FileType.image).toList();
    // var videos =
    //     recoveredFiles.where((file) => file.type == FileType.video).toList();
    // var audios =
    //     recoveredFiles.where((file) => file.type == FileType.audio).toList();
    // var documents =
    //     recoveredFiles.where((file) => file.type == FileType.document).toList();

    Get.toNamed(AppRoutes.SCANNING, arguments: {});
  }
}
