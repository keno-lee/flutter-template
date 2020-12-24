import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  /*
   * 设置token
   */
  static setToken(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', value);
  }

  /*
   * 获取token
   * attention！！！ 如果没有值，返回值为null
   */
  static Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.containsKey('token') ? prefs.getString('token') : null);
    return prefs.containsKey('token') ? prefs.getString('token') : '';
  }

  /*
   * 移除token
   */
  static Future removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      prefs.remove('token');
    }
  }

  static Future localeSet(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> localeGet(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? prefs.getString(key) : '';
  }

  static Future localeRemove(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      prefs.remove(key);
    }
  }
}
