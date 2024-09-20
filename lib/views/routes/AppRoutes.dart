import 'package:get/get.dart';
import 'package:photo_recovery/views/screens/AudiosPage.dart';
import 'package:photo_recovery/views/screens/DeatailImagesPage.dart';
import 'package:photo_recovery/views/screens/DetailAudiosPage.dart';
import 'package:photo_recovery/views/screens/DetailVideosPage.dart';
import 'package:photo_recovery/views/screens/DocumentsPage.dart';
import 'package:photo_recovery/views/screens/HomePage.dart';
import 'package:photo_recovery/views/screens/ImagesPage.dart';
import 'package:photo_recovery/views/screens/ScannedPage.dart';
import 'package:photo_recovery/views/screens/ScanningPage.dart';
import 'package:photo_recovery/views/screens/SplashView.dart';
import 'package:photo_recovery/views/screens/VideosPage.dart';

class AppRoutes {
  static const SPLASH = '/';
  static const HOMESCREEN = '/home';
  static const SCANNING = '/scanning';
  static const SCANNED = '/scanned';
  static const IMAGESPAGE = '/images_page';
  static const DETAILIMAGESPAGE = '/detail_images_page';
  static const VIDEOSPAGE = '/video_page';
  static const DETAILVIDEOSPAGE = '/detail_video_page';
  static const AUDIOSPAGE = '/audio_page';
  static const DETAILAUDIOSPAGE = '/detail_audio_page';
  static const DOCUMENTPAGE = '/detail_document_page';

  static final routes = [
    GetPage(
      name: SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: HOMESCREEN,
      page: () => HomePage(),
    ),
    GetPage(
      name: SCANNING,
      page: () => const ScanningPage(),
    ),
    GetPage(
      name: SCANNED,
      page: () => const ScannedPage(),
    ),
    GetPage(
      name: IMAGESPAGE,
      page: () => const ImagesPage(),
    ),
    GetPage(
      name: VIDEOSPAGE,
      page: () => const VideosPage(),
    ),
    GetPage(
      name: DOCUMENTPAGE,
      page: () => DocumentsPage(),
    ),
    GetPage(
      name: AUDIOSPAGE,
      page: () => AudiosPage(),
    ),
    GetPage(
      name: DETAILVIDEOSPAGE,
      page: () => const DetailVideosPage(),
    ),
    GetPage(
      name: DETAILIMAGESPAGE,
      page: () => const DetailImagesPage(),
    ),
    GetPage(
      name: DETAILAUDIOSPAGE,
      page: () => const DetailAudiosPage(),
    ),
  ];
}
