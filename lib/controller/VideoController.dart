import 'dart:developer';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:path_provider/path_provider.dart';

class VideoController extends GetxController {
  var videos = <FileModel>[].obs;
  var isLoading = true.obs;
  var thumbnailCache = <String, String?>{}.obs;


  void setVideos(List<FileModel> newVideos) {
    videos.assignAll(newVideos);
    isLoading.value = false;
  }

 Future<String?> getThumbnail(String videoPath) async {
    if (thumbnailCache.containsKey(videoPath)) {
      return thumbnailCache[videoPath];
    }

    try {
      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );
      thumbnailCache[videoPath] = thumbnail;
      log('Generated thumbnail: $thumbnail');
      return thumbnail;
    } catch (e) {
      log("Error fetching thumbnail: $e");
      return null;
    }
  }
}