import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> checkAndRequestPermissions() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      log('SDK Version: $sdkInt');

      if (sdkInt >= 33) {
        await _requestAllPermissions();
      } else if (sdkInt >= 30) {
        await _requestManageExternalStorage();
      } else {
        await _requestStoragePermission();
        log('SDK Version is $sdkInt, only storage permission requested.');
      }
    } catch (e) {
      log('Error checking device info or requesting permissions: $e');
    }
  }

  static Future<void> _requestAllPermissions() async {
    await _requestPermission(Permission.photos, 'Photos');
    await _requestPermission(Permission.videos, 'Videos');
    await _requestPermission(Permission.audio, 'Audios');
    await _requestPermission(Permission.mediaLibrary, 'Media Library');
    await _requestPermission(Permission.accessMediaLocation, 'Media Location');
  }

  static Future<void> _requestManageExternalStorage() async {
    final status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      final result = await Permission.manageExternalStorage.request();
      if (result.isGranted) {
        log('Manage External Storage permission granted.');
      } else {
        log('Manage External Storage permission denied.');
        _showSettingsSnackbar();
      }
    } else {
      log('Manage External Storage permission already granted.');
    }
  }

  static Future<void> _requestStoragePermission() async {
    await _requestPermission(Permission.storage, 'Storage');
  }

  static Future<void> _requestPermission(
      Permission permission, String permissionName) async {
    final status = await permission.status;

    if (!status.isGranted) {
      final result = await permission.request();
      if (result.isGranted) {
        log('$permissionName permission granted.');
      } else {
        log('$permissionName permission denied.');
        _showSettingsSnackbar();
      }
    } else {
      log('$permissionName permission already granted.');
    }
  }

  static void _showSettingsSnackbar() {
    try {
      log("Please grant the required permissions in the app settings.");
    } catch (e) {
      log('Error displaying snackbar: $e');
    }
  }
}

enum AppPermissionStatus {
  Granted,
  Denied,
  Restricted,
  PermanentlyDenied,
  Unknown,
}

/// Function to request external storage permission and return the status
Future<AppPermissionStatus> requestExternalStoragePermission() async {
  final status = await Permission.manageExternalStorage.request();

  if (status.isGranted) {
    return AppPermissionStatus.Granted;
  } else if (status.isDenied) {
    return AppPermissionStatus.Denied;
  } else if (status.isRestricted) {
    return AppPermissionStatus.Restricted;
  } else if (status.isPermanentlyDenied) {
    return AppPermissionStatus.PermanentlyDenied;
  } else {
    // Handle other statuses or exceptions
    return AppPermissionStatus.Unknown;
  }
}
