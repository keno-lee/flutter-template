import 'package:fluro/fluro.dart';

class Application {
  static Router router;

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  static Future navigateTo(
    context,
    String path, {
    Map<String, dynamic> params,
    TransitionType transition = TransitionType.cupertino,
  }) {
    print('====跳转页面====$path');
    print('====跳转参数====$params');
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key].toString());
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('====跳转参数拼接====$query');
    path = path + query;
    return router.navigateTo(
      context,
      path,
      transition: transition,
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }
}
