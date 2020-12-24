import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:template/utils/preferences.dart';
import 'package:connectivity/connectivity.dart';

const BASE_URL = "http://106.14.183.201:29999"; // 开发1

HttpUtil httpUtil = new HttpUtil();

class HttpUtil {
  static HttpUtil instance;
  Dio dio;
  BaseOptions options;
  String token;

  Future<bool> checkConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static HttpUtil getInstance() {
    if (null == instance) instance = new HttpUtil();
    return instance;
  }

  HttpUtil() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    options = new BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: BASE_URL,
      // 连接服务器超时时间，单位是毫秒.
      connectTimeout: 20000,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 20000,
      //Http请求头.
      headers: {},
      //请求的Content-Type，默认值是[ContentType.json]. 也可以用ContentType.parse("application/x-www-form-urlencoded")
      contentType: "application/x-www-form-urlencoded",
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    dio = new Dio(options);

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        // print("请求之前");
        var isConnected = await checkConnected();
        if (!isConnected) {
          showToast('please check your internet');
          return false;
        }
        var token = await Prefs.getToken();
        print('token------ $token');
        options.headers['token'] = token; // 放入token
        return options; //continue
      },
      onResponse: (Response response) {
        print("响应之前");
        // Do something with response data
        return response; // continue
      },
      onError: (DioError e) {
        print("错误之前");
        // Do something with response error
        return e; //continue
      },
    ));
  }

  /*
   * get请求
   */
  Future get(String url, [data]) async {
    Response response;
    try {
      response = await dio.get(url, queryParameters: data);
      print('请求路径------$url');
      print('接口入参------$data');
      print('接口状态------${response.statusCode}');
      print('返回数据------${response.data}');
    } on DioError catch (e) {
      print('$url GET报错---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * post请求
   */
  Future post(String url, [data, Options options]) async {
    Response response;
    try {
      response = await dio.post(url, data: data, options: options);
      print('请求路径------$url');
      print('接口入参------$data');
      print('接口状态------${response.statusCode}');
      print('返回数据------${response.data}');
    } on DioError catch (e) {
      print('$url POST报错---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * put请求
   */
  Future put(String url, [data]) async {
    Response response;
    try {
      response = await dio.put(url, data: data);
      print('请求路径------$url');
      print('接口入参------$data');
      print('接口状态------${response.statusCode}');
      print('返回数据------${response.data}');
    } on DioError catch (e) {
      print('$url put报错---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * delete请求
   */
  Future delete(String url) async {
    Response response;
    try {
      response = await dio.delete(url);
      print('请求路径------$url');
      print('接口状态------${response.statusCode}');
      print('返回数据------${response.data}');
    } on DioError catch (e) {
      print('$url delete报错---------$e');
      formatError(e);
    }
    return response.data;
  }

  /*
   * error统一处理
   */
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      showToast('connect timeout');
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      showToast('send timeout');
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      showToast('receive timeout');
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      showToast('http error');
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      showToast('http cancel');
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      showToast('unknown error');
    }
  }
}
