import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/routers/routes.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _determine() async {
    var raw = await httpUtil.delete('/accountClose');

    if (raw['status'] == 200) {
      Prefs.removeToken();
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.root,
        (route) => route == null,
      );
    } else {
      showToast(raw['message']);
    }
  }

  void _cancelAccount() {
    showDialog(
      // 点击阴影是否关闭
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.only(
          top: ScreenUtil().setWidth(16),
          bottom: ScreenUtil().setWidth(20),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
        ),
        content: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to cancel your account?',
                  style: TextStyle(
                    color: StyleColors.defaultColor,
                    fontSize: ScreenUtil().setWidth(15),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _determine,
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(99),
                          height: ScreenUtil().setWidth(33),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 1,
                              color: StyleColors.tertiaryColor,
                            ),
                          ),
                          child: Text(
                            'Determine',
                            style: TextStyle(
                              color: StyleColors.tertiaryColor,
                              fontSize: ScreenUtil().setWidth(15),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 16),
                          width: ScreenUtil().setWidth(99),
                          height: ScreenUtil().setWidth(33),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: StyleColors.pirmaryColor,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setWidth(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // AlertDialog(
      //   content: Text('Are you sure you want to cancel your account?'),
      //   actions: <Widget>[
      //     FlatButton(
      //       onPressed: _determine,
      //       color: StyleColors.tertiaryColor,
      //       child: Text('Determine'),
      //     ),
      //     FlatButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       color: StyleColors.pirmaryColor,
      //       child: Text('Cancel'),
      //     ),
      //   ],
      // ),
    );
  }

  void _logout() {
    showDialog(
      // 点击阴影是否关闭
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.only(
          top: ScreenUtil().setWidth(16),
          bottom: ScreenUtil().setWidth(20),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
        ),
        content: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    color: StyleColors.defaultColor,
                    fontSize: ScreenUtil().setWidth(15),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Prefs.removeToken();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.root,
                            (route) => route == null,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(99),
                          height: ScreenUtil().setWidth(33),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 1,
                              color: StyleColors.tertiaryColor,
                            ),
                          ),
                          child: Text(
                            'Determine',
                            style: TextStyle(
                              color: StyleColors.tertiaryColor,
                              fontSize: ScreenUtil().setWidth(15),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 16),
                          width: ScreenUtil().setWidth(99),
                          height: ScreenUtil().setWidth(33),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: StyleColors.pirmaryColor,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setWidth(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //   Text('Are you sure you want to logout?'),
        //   actions: <Widget>[
        //     FlatButton(
        //       onPressed: () {
        //         Prefs.removeToken();
        //         Navigator.pushNamedAndRemoveUntil(
        //           context,
        //           Routes.root,
        //           (route) => route == null,
        //         );
        //       },
        //       color: StyleColors.tertiaryColor,
        //       child: Text('Determine'),
        //     ),
        //     FlatButton(
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       color: StyleColors.pirmaryColor,
        //       child: Text('Cancel'),
        //     ),
        //   ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(16),
          left: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _cancelAccount,
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(325),
                height: ScreenUtil().setWidth(50),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(80),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: StyleColors.pirmaryColor,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setWidth(16),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _logout,
              child: Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(325),
                height: ScreenUtil().setWidth(50),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(30),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: StyleColors.pirmaryColor),
                  color: Colors.white,
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: StyleColors.pirmaryColor,
                    fontSize: ScreenUtil().setWidth(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
