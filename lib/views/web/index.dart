import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WebPage extends StatefulWidget {
  final String url;
  WebPage({Key key, @required this.url}) : super(key: key);
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String url; // url链接
  String title = ''; // 网页标题

  WebViewController _webViewController;

  void getWebTitle() async {
    String windowTitleScript = 'window.document.title';
    var titleTmp = await _webViewController
        .evaluateJavascript(windowTitleScript); // 实现js方法
    setState(() {
      this.title = titleTmp.replaceAll('"', '');
      print(this.title);
    });
  }

  //  js 调用 flutter 定义方法 => 使用方法: flutter.postMessage('弹弹乐');
  JavascriptChannel _flutterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'flutter',
      onMessageReceived: (JavascriptMessage message) {
        print(3333333);
        print(message.message);
        // Layer.showAndroidMessage(message: message.message);
        Navigator.pop(context);
      },
    );
  }

  // JavascriptChannel _flutter2JavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'flutter2',
  //       onMessageReceived: (JavascriptMessage message) {
  //         print(3333333);
  //         print(message.message);
  //         // message.message()
  //         // Layer.showAndroidMessage(message: message.message);
  //         _webViewController
  //             .evaluateJavascript('${message.message}(25)')
  //             .then((result) {});
  //       });
  // }

  // void setWindow() {
  //   // String script = 'window.dsqapi=function(){console.log(12345)}';
  //   List scriptList = [
  //     'window["jsbridge"]={}', // 必须要
  //     'window["jsbridge"]["fc1"]=function(callback){flutter2.postMessage(callback)}',
  //     'window["jsbridge"]["fc2"]=function(callback){callback()}',
  //     'window.alert=function(value){flutter.postMessage(value)}',
  //     'window.alert2=function(callback){flutter2.postMessage(callback)}',
  //   ];
  //   for (var item in scriptList) {
  //     _webViewController.evaluateJavascript(item).then((result) {});
  //   }
  // }

  _download(BuildContext context, String url) async {
    if (Platform.isIOS) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else if (Platform.isAndroid) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  void initState() {
    url = widget.url;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _webViewController.canGoBack().then((value) {
              if (value) {
                _webViewController.goBack();
              } else {
                Navigator.pop(context);
              }
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: WebView(
        // 小小影视 http://www.xiao.mx/
        // 小小影视下载 itms-services://?action=download-manifest&url=https%3A%2F%2Fapp-rnqmlh.lelefenxi
        // https://itunes.apple.com/cn/app/id1478595243
        //   || request.url.indexOf('.apk') > -1
        // 畅享花下载 http://pkg.hiapp.fun/ipa/8dcc088483a8466382cd51f705d20975.apk?auth_key=1572608138-0-0-b52763cfe9769153d6286d61db9d322d
        // 畅享花下载 itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.51gsc.com%2Finstall%2Ff19d58eab2723588492e62ecb5f63450

        // http://app-rnqmlh.lelefenxi.com/install/c/eyJtIjoiSW9GeEswT2g0c1FBQUFGdVA1VGdPUjBNUHh4VVFzakpXbmxOZWljMjRnWENieHhBV05Pb0h1
        // rnqmlh://lelefenxi.com/c/eyJtIjoiSFA5MUhTSXcxaHdBQUFGdVA1Z0VGLVRNSGxROTVjSE83VTVzcm9rQnRiaURZa092NWtNdnRGM0xiamsifQ==
        navigationDelegate: (NavigationRequest request) {
          // print('代理1');
          // print(request.url);
          // print('代理2');
          // ios 匹配规则
          // 1.https://apps.apple.com/cn/app/id1475210536
          // 2.https://itunes.apple.com/cn/app/id1475210536
          // 3.itms-services://?action=download-manifest&url=https%3A%2F%2Fapp-rnqmlh.lelefenxi
          // android 匹配规则
          // http://pkg.hiapp.fun/ipa/01377aa3abb045cfb9bacbea42c6864a.apk?auth_key=1573028814-0-0-5eccf3ddf8c923f3a6932ea2967319c7
          if (request.url.indexOf('itms-services://') > -1 ||
              request.url.indexOf('itunes') > -1 ||
              request.url.indexOf('apps') > -1 ||
              request.url.indexOf('.apk') > -1) {
            // print('符合规则1');
            _download(context, request.url);
            return NavigationDecision.prevent;
          } else if (Platform.isAndroid && request.url.indexOf('http') < 0) {
            // print('符合规则2');
            // 防止安卓打开协议下的其他app
            return NavigationDecision.prevent;
          } else if (request.url.indexOf('http') > -1) {
            // print('符合规则3');
            return NavigationDecision.navigate;
          }
        },
        initialUrl: this.url,
        javascriptMode: JavascriptMode.unrestricted, // 使用JS没限制
        javascriptChannels: <JavascriptChannel>[
          // javascriptChannels
          _flutterJavascriptChannel(context),
          // _flutter2JavascriptChannel(context)
        ].toSet(),
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          webViewController.canGoBack().then((res) {});
          // webViewController.currentUrl().then((url) {
          //   print(url); // 返回当前url
          // });
          // webViewController.canGoForward().then((res) {
          //   print(res); //是否能前进
          // });
        },
        onPageFinished: (String value) {
          getWebTitle(); // 调用js获取网页title
          // 返回当前url
          // print(value);
        },
      ),
    );
  }
}
