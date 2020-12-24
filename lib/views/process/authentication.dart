import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/routers/routes.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  Timer timer;
  loadData() {
    timer = new Timer(new Duration(seconds: 3), () {
      // 只在倒计时结束时回调
      Navigator.pushReplacementNamed(context, Routes.getloan);
    });
  }

  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: StyleColors.pirmaryColor,
          image: DecorationImage(
            image: AssetImage('lib/assets/process/authentication_bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16),
            right: ScreenUtil().setWidth(16),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(
                  'Get Credit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                automaticallyImplyLeading: false, //设置没有返回按钮
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StyleText(
                    text: 'We are assessing your credit',
                    color: StyleColors.defaultColor,
                    size: ScreenUtil().setWidth(18),
                  ),
                  Container(height: 10),
                  StyleText(
                    text:
                        'This should only take a couple of minutes we will notify you once we have assessed your credit.',
                    color: StyleColors.secondaryColor,
                    size: ScreenUtil().setWidth(13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     title: Text(
    //       'Get Credit',
    //       style: TextStyle(color: Color(0xff333333)),
    //     ),
    //     automaticallyImplyLeading: false, //设置没有返回按钮
    //     centerTitle: true,
    //     backgroundColor: StyleColors.pirmaryColor,
    //     elevation: 0,
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.only(
    //       left: ScreenUtil().setWidth(60),
    //       right: ScreenUtil().setWidth(60),
    //       bottom: ScreenUtil().setWidth(30),
    //     ),
    //     width: double.infinity,
    //     height: double.infinity,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage('lib/assets/task/repay_bg.png'),
    //         fit: BoxFit.cover,
    //         alignment: Alignment.topCenter,
    //       ),
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         StyleText(
    //           text: 'We are assessing your credit',
    //           color: StyleColors.defaultColor,
    //           size: ScreenUtil().setWidth(18),
    //         ),
    //         Container(height: 10),
    //         StyleText(
    //           text:
    //               'This should only take a couple of minutes we will notify you once we have assessed your credit.',
    //           color: StyleColors.secondaryColor,
    //           size: ScreenUtil().setWidth(13),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
