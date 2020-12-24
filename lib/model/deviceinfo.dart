import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '../api/index.dart';
import 'package:geolocator/geolocator.dart';
import 'package:template/utils/preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceInfo {
  Future loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    androidInfo = await deviceInfo.androidInfo;
    packageInfo = await PackageInfo.fromPlatform();

    // print('Running on ${androidInfo.version.codename}');
    // print('Running on ${androidInfo.version.release}');
    // print('Running on ${androidInfo.version.baseOS}');

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    print('Running on ${packageInfo.version}');
  }

  // 上传设备信息
  static uploadDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    var packageInfo = await PackageInfo.fromPlatform();

    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.location,
    // ].request();
    // // PermissionStatus.denied
    // print('000------${statuses[Permission.location]}-----000');
    // if (statuses[Permission.location] == PermissionStatus.granted) {
    //   Prefs.localeSet('location', 'granted');
    // } else {
    //   Prefs.localeSet('location', 'denied');
    //   return;
    // }
    Geolocator geolocator = Geolocator();
    Position position =
        await geolocator.getCurrentPosition().timeout(Duration(seconds: 10));
    // print(5);

    // print('位置${position.latitude}');
    // print('位置${position.longitude}');

    // print(androidInfo.device); // c5proltechn
    // print(androidInfo.androidId); // 2454269f0c893acb
    // print('lang');
    // print('latitude');
    // print('longitude');
    // print(androidInfo.brand); // samsung
    // print(androidInfo.model); // SM-C5010
    // print("android"); //
    // print(packageInfo.version); // 1.0.0
    var lang = await Prefs.localeGet('lang');
    var raw = await httpUtil.post('/device', {
      "device_id": androidInfo.androidId, // 2454269f0c893acb
      "lang": lang,
      "latitude": position != null ? position.latitude : '',
      "longitude": position != null ? position.longitude : '',
      "brand": androidInfo.brand,
      "model": androidInfo.model,
      "system": "android",
      "version": packageInfo.version,
    });

    // if (raw['status'] == 200) {
    //   Prefs.localeSet('location', 'granted');
    // } else {
    //   Prefs.localeSet('location', 'denied');
    // }
    return raw['status'];
  }

  AndroidDeviceInfo androidInfo;
  PackageInfo packageInfo;
  // 安卓id
  String get androidId => androidInfo.androidId;
  // 当前app的版本号
  String get version => packageInfo.version;
}
