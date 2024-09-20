import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';
import 'package:photo_recovery/views/routes/AppRoutes.dart';
import 'package:photo_recovery/views/utils/ImageUtils.dart';
import 'package:get_storage/get_storage.dart';

class ScannedPageController extends GetxController {
  final box = GetStorage();

  var photosCount = 0.obs;
  var videosCount = 0.obs;
  var audioCount = 0.obs;
  var documentCount = 0.obs;

  List<FileModel> photosList = [];
  List<FileModel> videosList = [];
  List<FileModel> audioList = [];
  List<FileModel> documentList = [];

  List<Map> ScannedList = [
    {
      'ImageURL': PngImages.PNGPath + PngImages.ImageScannedVector,
      'Name': "Images",
      'onTap': AppRoutes.IMAGESPAGE,
    },
    {
      'ImageURL': PngImages.PNGPath + PngImages.VideoScannedVector,
      'Name': "Videos",
      'onTap': AppRoutes.VIDEOSPAGE,
    },
    {
      'ImageURL': PngImages.PNGPath + PngImages.AudioScannedVector,
      'Name': "Audios",
      'onTap': AppRoutes.AUDIOSPAGE,
    },
    {
      'ImageURL': PngImages.PNGPath + PngImages.DocumentsScannedVector,
      'Name': "Documents",
      'onTap': AppRoutes.DOCUMENTPAGE,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadCounts();
  }

  @override
  void onClose() {
    _saveCounts();
    super.onClose();
  }

  void setData(List<FileModel> images, List<FileModel> videos, List<FileModel> audios, List<FileModel> documents) {
    photosList.assignAll(images);
    videosList.assignAll(videos);
    audioList.assignAll(audios);
    documentList.assignAll(documents);

    photosCount.value = photosList.length;
    videosCount.value = videosList.length;
    audioCount.value = audioList.length;
    documentCount.value = documentList.length;

    _saveCounts();
  }

  void _saveCounts() {
    box.write('photosCount', photosCount.value);
    box.write('videosCount', videosCount.value);
    box.write('audioCount', audioCount.value);
    box.write('documentCount', documentCount.value);
  }

  void _loadCounts() {
    photosCount.value = box.read('photosCount') ?? 0;
    videosCount.value = box.read('videosCount') ?? 0;
    audioCount.value = box.read('audioCount') ?? 0;
    documentCount.value = box.read('documentCount') ?? 0;
  }
}
