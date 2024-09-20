import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DetailImageController extends GetxController {
  var imagePaths = <String>[].obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    currentIndex.value = arguments['imageIndex'];
    imagePaths.assignAll(arguments['imagePaths']);
  }

  Future<void> downloadImage() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      final imagePath = imagePaths[currentIndex.value];
      final file = File(imagePath);
      if (!await file.exists()) {
        Get.snackbar('Error', 'Image file does not exist at path $imagePath');
        return;
      }

      // Request permissions
      if (sdkInt >= 33) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied', 'Manage External Storage permission is required to save the image');
          return;
        }
      } else {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar('Permission Denied', 'Storage permission is required to save the image');
          return;
        }
      }

      // Ensure the directory exists
      final downloadsDirectory = Directory('/storage/emulated/0/Download/DataRecovery');
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
        log('Created directory: ${downloadsDirectory.path}');
      }

      final fileExtension = path.extension(file.path);
      final uniqueFilename = '${const Uuid().v4()}$fileExtension';
      final newFilePath = '${downloadsDirectory.path}/$uniqueFilename';

      // Copy the file
      await file.copy(newFilePath);

      Get.snackbar('Success', 'Image downloaded to $newFilePath');
      log('Image copied to $newFilePath');
    } catch (e) {
      Get.snackbar('Oops...', 'Failed to download image');
      log('Failed to download image: $e');
    }
  }
}
