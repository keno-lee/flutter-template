import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/style/padding.dart';
import 'package:template/components/button.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/preferences.dart';
import 'package:template/utils/track.dart';
import 'package:template/routers/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isCountdown = false; // 是否在倒计时中
  Timer _countdownTimer; // 倒计时定时器
  int _seconds; // 倒计时秒数
  String _btnCountdownStr = 'Send Code'; // 按钮文案
  bool _btnActive = false; // 是否激活按钮

  void initCountDown() {
    _seconds = 60;
    _btnCountdownStr = 'Send Code';
    _isCountdown = false;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    setState(() {});
  }

  void _getOtp() async {
    countDown();
    if (_phoneController.text == '') {
      showToast('Please Enter Mobile');
      return;
    }
    countDown();

    var raw = await httpUtil.post('/verificationCode', {
      'mobile': _phoneController.text,
    });

    if (raw['status'] == 200) {
      showToast('Verification code sent');
    } else {
      showToast(raw['message']);
      initCountDown();
    }
  }

  void _login() async {
    if (_otpController.text == '') {
      showToast('Please Enter Verification Code');
      return;
    }
    var raw = await httpUtil.post('/login', {
      'mobile': _phoneController.text,
      'code': _otpController.text,
      // 'channel': '',
    });

    if (raw['status'] == 200) {
      await track.login();
      if (raw['data']['is_new'] != null && raw['data']['is_new'] == 1) {
        await track.register();
      }

      showToast('Login Success');
      await Prefs.setToken(raw['data']['token']); // 存储token
      // Navigator.pop(context);
      // 需要起始页完全加载，所以使用该回退方式
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.root,
        (route) => route == null,
      );
    } else {
      showToast(raw['message']);
    }
  }

  // 监听input文案变化
  void _textFieldChanged(String str) {
    if (_phoneController.text.length >= 10 && _otpController.text.length > 0) {
      _btnActive = true;
    } else {
      _btnActive = false;
    }
    setState(() {});
  }

  // 倒计时
  void countDown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      _isCountdown = true;
      _btnCountdownStr = '${_seconds--}s';
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_seconds > 0) {
            _btnCountdownStr = '${_seconds--}s';
          } else {
            _isCountdown = false;
            _btnCountdownStr = 'Resend';
            _seconds = 60;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  @override
  void initState() {
    initCountDown();
    super.initState();
  }

  // 生命周期结束时销毁定时器
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
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
            image: AssetImage('lib/assets/profile/login_bg.png'),
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
              SafeArea(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: ScreenUtil().setWidth(65),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              Text(
                'Registration with the mobile  number which is linked to your Aadhaar card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setWidth(14),
                  decoration: TextDecoration.none,
                ),
              ),
              Container(height: ScreenUtil().setWidth(55)),
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: ScreenUtil().setWidth(286),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      right: ScreenUtil().setWidth(16),
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/profile/login_bg_02.png'),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: TextField(
                            controller: _phoneController,
                            onChanged: _textFieldChanged,
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Mobile Number',
                              prefixIcon: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(30),
                                child: StyleText(
                                  text: '+91',
                                  color: StyleColors.defaultColor,
                                  size: ScreenUtil().setWidth(16),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: _otpController,
                            onChanged: _textFieldChanged,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter Verification Code',
                              suffixIcon: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(94),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(94),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        width: 1,
                                        color: StyleColors.weakenColor,
                                      ),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: _getOtp,
                                    child: StyleText(
                                      text: _btnCountdownStr,
                                      color: _isCountdown
                                          ? StyleColors.tertiaryColor
                                          : StyleColors.pirmaryColor,
                                      size: ScreenUtil().setWidth(16),
                                    ),
                                  ),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 15),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Button(
                            text: 'Log in',
                            active: _btnActive,
                            onTap: _login,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: ScreenUtil().setWidth(-33),
                    // left: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(75),
                      height: ScreenUtil().setWidth(75),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('lib/assets/profile/login_logo.png'),
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopPart extends StatelessWidget {
  const TopPart({Key key}) : super(key: key);

  void _back(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(165),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/profile/login_bg.png'),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      child: SafeArea(
        child: StylePadding(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _back(context);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setWidth(65),
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                child: StyleText(
                  text:
                      'Registration with the mobile  number which is linked to your Aadhaar card',
                  color: Colors.white,
                  size: ScreenUtil().setWidth(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPart extends StatelessWidget {
  // final TextEditingController phoneController;
  // final TextEditingController otpController;
  const LoginPart({
    Key key,
    // this.phoneController,
    // this.otpController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(42),
          color: Colors.red,
          child: Row(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: ScreenUtil().setWidth(30),
                ),
                textAlign: TextAlign.right,
                decoration: InputDecoration.collapsed(hintText: '手机号'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
