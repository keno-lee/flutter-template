import 'package:permission_handler/permission_handler.dart';
import './preferences.dart';

class MyPermissions {
  static requestPermission() async {
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.location,
    //   // Permission.storage,
    // ].request();
    // print('----------------');
    // print(statuses[Permission.location]);
    // print(statuses[Permission.storage]);
    // print(statuses[Permission.locationAlways]);
    // print(statuses[Permission.locationWhenInUse]);
    // print('----------------');

    var status = await Permission.location.status;
    print('212222222-================');
    print(status);
    // if (statuses[Permission.location] == PermissionStatus.denied) {
    //   // 如果权限申请失败，记录下来，app禁止使用
    // }

    // // PermissionStatus.denied
    // if (statuses[Permission.location] == PermissionStatus.granted) {
    //   Prefs.localeSet('location', 'granted');
    // } else {
    //   Prefs.localeSet('location', 'denied');
    // }
  }
}
