import 'dart:developer';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashController extends GetxController {
  var isVideoPlayed = false.obs;
  late VideoPlayerController videoController;
  var isFault = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeVideo();
  }

  void _initializeVideo() {
    videoController = VideoPlayerController.asset('assets/videos/Loader.mp4')
      ..initialize().then((_) {
        videoController.play();
        videoController.setLooping(false);
        videoController.addListener(_videoListener);
      }).catchError((error) {
        isFault.value = true;
        log('Video initialization error: $error');
      });
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
    videoController.removeListener(_videoListener);
    videoController.dispose();
    super.onClose();
  }
}