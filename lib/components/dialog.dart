import 'package:flutter/material.dart';
import './button.dart';

///created by WGH
///on 2020/7/23
///description:版本更新提示弹窗
class CustomDialog extends Dialog {
  final String title; // 文案
  final String content; // 内容
  final bool hasClose; // 是否强制
  final Function close; // 点击关闭
  final Function onTap;
  final String btnText; // 按钮内容

  CustomDialog({
    this.title,
    this.content,
    this.hasClose: true,
    this.close,
    this.onTap,
    this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      titlePadding: EdgeInsets.all(6),
      contentPadding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 16,
      ),
      title: Column(
        children: <Widget>[
          hasClose
              ? GestureDetector(
                  onTap: () {
                    close == null ? Navigator.pop(context) : close();
                  },
                  child: Container(
                    height: 20,
                    child: Icon(
                      Icons.close,
                      color: Color(0xff999999),
                      size: 18,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                )
              : Container(height: 20),
          title != null
              ? Container(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(),
                  ),
                )
              : Container(),
        ],
      ),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff666666)),
              ),
            ),
            Button(
              width: 220,
              height: 35,
              onTap: onTap,
              text: btnText ?? 'OK',
              active: true,
            )
          ],
        ),
      ),
    );
  }

  static show(
    BuildContext context, {
    String title,
    String content,
    bool hasClose,
    Function onTap,
    Function close,
    String btnText,
  }) {
    return showDialog(
      // 点击阴影是否关闭
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: CustomDialog(
            title: title,
            content: content,
            hasClose: hasClose,
            onTap: onTap,
            close: close,
            btnText: btnText,
          ),
          onWillPop: _onWillPop,
        );
      },
    );
  }

  // 点击返回拦截关闭
  static Future<bool> _onWillPop() async {
    return false;
  }
}
