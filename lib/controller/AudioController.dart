import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:photo_recovery/model/FileModel.dart';

class AudioController extends GetxController {
  final audioPlayer = AudioPlayer();
  var currentIndex = 0.obs;
  var isPlaying = false.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;
  List<FileModel> audioFiles = [];

  @override
  void onInit() {
    super.onInit();
    audioPlayer.onDurationChanged.listen((duration) {
      totalDuration.value = duration;
    });
    audioPlayer.onPositionChanged.listen((position) {
      currentPosition.value = position;
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }

  void setAudio(List<FileModel> newFiles) {
    audioFiles.assignAll(newFiles);
  }

  void setAudioFiles(List<FileModel> files) {
    audioFiles = files;
  }

  Future<void> playAudio(int index, String audioPath) async {
    try {
      currentIndex.value = index;
      final file = File(audioPath);

      if (!await file.exists()) {
        Get.snackbar('Oops...', 'Audio file not found.');
        return;
      }

      await audioPlayer.play(DeviceFileSource(file.path));
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Oops...', 'Failed to play audio');
      log("Failed to play audio: $e");
    }
  }

  void pauseAudio() async {
    try {
      await audioPlayer.pause();
      isPlaying.value = false;
    } catch (e) {
      Get.snackbar('Sorry', 'Failed to pause audio');
    }
  }

  void resumeAudio() async {
    try {
      await audioPlayer.resume();
      isPlaying.value = true;
    } catch (e) {
      Get.snackbar('Sorry', 'Failed to resume audio');
    }
  }

  void stopAudio() async {
    try {
      await audioPlayer.stop();
      isPlaying.value = false;
      currentPosition.value = Duration.zero;
    } catch (e) {
      Get.snackbar('Sorry', 'Failed to stop audio');
    }
  }

  void playNext() {
    if (currentIndex.value < audioFiles.length - 1) {
      playAudio(
          currentIndex.value + 1, audioFiles[currentIndex.value + 1].path);
    } else {
      Get.snackbar('Info', 'No more audio files.');
    }
  }

  void playPrevious() {
    if (currentIndex.value > 0) {
      playAudio(
          currentIndex.value - 1, audioFiles[currentIndex.value - 1].path);
    } else {
      Get.snackbar('Info', 'No previous audio files.');
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  Future<void> downloadAudio() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      const downloadPath = '/storage/emulated/0/Download/DataRecovery';
      if (androidInfo.isPhysicalDevice) {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          final filePath =
              '${downloadPath}audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
          final file = File(filePath);
          await file.writeAsBytes(
              await File(audioFiles[currentIndex.value].path).readAsBytes());
          Get.snackbar('Success', 'Audio downloaded to $filePath');
        } else {
          Get.snackbar('Permission Denied',
              'Storage permission is required to download files');
        }
      } else {
        Get.snackbar('Error', 'Not a physical device');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download audio: $e');
    }
  }
}
