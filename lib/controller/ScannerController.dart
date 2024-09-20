import 'dart:developer';
import 'package:get/get.dart';
import 'package:photo_recovery/controller/ScannedController.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:video_player/video_player.dart';

import '../model/FileServiceTest.dart';

class ScannerController extends GetxController {
  List<Map<String, dynamic>> rowsData = [];
  RxInt total = 0.obs;
  RxList<FileModel> images = <FileModel>[].obs;
  RxList<FileModel> videos = <FileModel>[].obs;
  RxList<FileModel> audios = <FileModel>[].obs;
  RxList<FileModel> documents = <FileModel>[].obs;
  var showGif = true.obs;
  var isFault = false.obs;

  var isVideoPlayed = false.obs;
  late VideoPlayerController videoController;
  RxBool isScanning = false.obs;
  var recoveredFiles = <FileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeRowsData();

    videoController = VideoPlayerController.asset('assets/videos/Success.mp4')
      ..initialize().then((_) {
        videoController.play();
        videoController.setLooping(false);
        videoController.addListener(_videoListener);
      }).catchError((error) {
        isFault.value = true;
        log('Video initialization error: $error');
      });
    startScanning();
  }

  void startScanning() async {
    isScanning.value = true;

    MovetoNewPageAfterScan();
    // updateRowsDataDirectly();
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
      images.assignAll(
          recoveredFiles.where((file) => file.type == FileType.image).toList());
      videos.assignAll(
          recoveredFiles.where((file) => file.type == FileType.video).toList());
      audios.assignAll(
          recoveredFiles.where((file) => file.type == FileType.audio).toList());
      documents.assignAll(recoveredFiles
          .where((file) => file.type == FileType.document)
          .toList());

      updateRowsDataDirectly();
      isScanning.value = false;
    }
  }

  void _videoListener() {
    if (videoController.value.hasError) {
      log('Playback error: ${videoController.value.errorDescription}');
      isFault.value = true;
      return;
    }

    if (videoController.value.position == videoController.value.duration) {
      isVideoPlayed.value = true;
    }
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }

  void initializeRowsData() {
    rowsData = [
      {
        'iconPath': "${ImageUtils.ImagePath}ImageIcon.png",
        'title': "Images",
        'count': 0,
        'total': 0,
      },
      {
        'iconPath': "${ImageUtils.ImagePath}VideoIcon.png",
        'title': "Videos",
        'count': 0,
        'total': 0,
      },
      {
        'iconPath': "${ImageUtils.ImagePath}AudioIcon.png",
        'title': "Audios",
        'count': 0,
        'total': 0,
      },
      {
        'iconPath': "${ImageUtils.ImagePath}DocumentIcon.png",
        'title': "Documents",
        'count': 0,
        'total': 0,
      },
    ];
  }

  void updateRowsData(Map<String, dynamic> arguments) {
    images = arguments['images'] ?? [];
    videos = arguments['videos'] ?? [];
    audios = arguments['audios'] ?? [];
    documents = arguments['documents'] ?? [];

    total.value =
        images.length + videos.length + documents.length + audios.length;

    rowsData[0]['count'] = images.length;
    rowsData[0]['total'] = total;
    rowsData[1]['count'] = videos.length;
    rowsData[1]['total'] = total;
    rowsData[2]['count'] = audios.length;
    rowsData[2]['total'] = total;
    rowsData[3]['count'] = documents.length;
    rowsData[3]['total'] = total;

    update();
    // printRowsData();
  }

  void updateRowsDataDirectly() {
    total.value =
        images.length + videos.length + documents.length + audios.length;

    rowsData[0]['count'] = images.length;
    rowsData[0]['total'] = total.value;
    rowsData[1]['count'] = videos.length;
    rowsData[1]['total'] = total.value;
    rowsData[2]['count'] = audios.length;
    rowsData[2]['total'] = total.value;
    rowsData[3]['count'] = documents.length;
    rowsData[3]['total'] = total.value;

    update();
    printRowsData();
  }

  void printRowsData() {
    for (var data in rowsData) {
      log("Title: ${data['title']}, Count: ${data['count']}, Total: ${data['total']}");
    }
  }

  void navigateToScannedPage() {
    var scannedPageController = Get.put(
      ScannedPageController(),
    );
    scannedPageController.setData(images, videos, audios, documents);

    Get.toNamed(AppRoutes.SCANNED);
  }
}
