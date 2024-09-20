import 'package:get/get.dart';
import 'package:photo_recovery/model/FileModel.dart';

class ImagesController extends GetxController {
  var images = <FileModel>[].obs;
  var isLoading = true.obs; // Loading state for the entire image list
  var imageLoadingStatus = <RxBool>[]; // List to track individual image loading states

  ImagesController();

  void setImages(List<FileModel> newImages) {
    images.assignAll(newImages);
    imageLoadingStatus = List.generate(newImages.length, (_) => true.obs); // Initialize loading states
    isLoading.value = false; // Set loading to false after images are set
  }

  // Function to set loading status for an individual image
  void setImageLoadingStatus(int index, bool loading) {
    if (index >= 0 && index < imageLoadingStatus.length) {
      imageLoadingStatus[index].value = loading;
    }
  }

  // Function to get individual image loading status
  RxBool getImageLoadingStatus(int index) {
    return imageLoadingStatus[index];
  }
}
