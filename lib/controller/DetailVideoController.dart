import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DetailVideoController extends GetxController {
  late VideoPlayerController controller;
  var isPlaying = false.obs;
  var videoPaths = <String>[].obs;
  var currentIndex = 0.obs;
  var thumbnails = <int, String?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    currentIndex.value = arguments['videoIndex'];
    videoPaths.assignAll(arguments['videoPaths']);

    initializeVideoController();
    loadAllThumbnails();
  }

  Future<void> initializeVideoController() async {
    controller =
        VideoPlayerController.file(File(videoPaths[currentIndex.value]))
          ..initialize().then((_) {
            isPlaying.value = false;
            update();
          });

    controller.addListener(() {
      isPlaying.value = controller.value.isPlaying;
    });
  }

  Future<void> loadAllThumbnails() async {
    for (int i = 0; i < videoPaths.length; i++) {
      String? thumbnail = await getThumbnail(videoPaths[i]);
      thumbnails[i] = thumbnail;
    }
    update();
  }

  Future<String?> getThumbnail(String videoPath) async {
    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );
      return thumbnail;
    } catch (e) {
      log("Error fetching thumbnail: $e");
      return null;
    }
  }

  void changeVideo(int index) {
    if (index >= 0 && index < videoPaths.length) {
      currentIndex.value = index;
      controller.dispose();
      initializeVideoController();
    }
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  Future<void> downloadVideo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied',
              'Storage permission is required to save the image');
          return;
        }
      } else {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied',
              'Storage permission is required to save the image');
          return;
        }
      }

      Directory? downloadsDirectory;

      if (Platform.isAndroid) {
        downloadsDirectory =
            Directory('/storage/emulated/0/Download/DataRecovery');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      } else {
        throw UnsupportedError("Platform not supported");
      }

      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      final fileName = videoPaths[currentIndex.value].split('/').last;
      final filePath = '${downloadsDirectory.path}/$fileName';

      final file = File(videoPaths[currentIndex.value]);
      await file.copy(filePath);

      Get.snackbar('Success', 'Video downloaded to $filePath');
    } catch (e) {
      Get.snackbar('Error', 'Failed to download video');
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
