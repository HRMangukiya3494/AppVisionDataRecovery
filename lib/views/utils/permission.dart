import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Permissions {
  static PermissionHandlerPlatform get _handler => PermissionHandlerPlatform.instance;

  static Future<bool> cameraFilesAndLocationPermissionsGranted() async {

      Map<Permission, PermissionStatus> cameraPermissionStatus;
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if(deviceInfo.version.sdkInt > 32){
        cameraPermissionStatus = await _handler.requestPermissions(
          [
            Permission.photos,
          ],
        );
      }else{
        cameraPermissionStatus = await _handler.requestPermissions(
          [
            Permission.storage,
          ],
        );
      }


      bool checkedTrue = true;
      for (var element in cameraPermissionStatus.values) {
        if (element == PermissionStatus.granted) {
          checkedTrue = true;
        } else if (element == PermissionStatus.permanentlyDenied) {
          openAppSettings();
          checkedTrue = false;
        } else {
          checkedTrue = false;
        }
      }

      return checkedTrue;
    }


}