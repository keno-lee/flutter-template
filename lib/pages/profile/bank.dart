import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Bank Account',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(80),
          right: ScreenUtil().setWidth(80),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(125),
                height: ScreenUtil().setWidth(144),
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(24)),
                child: Image.asset('lib/assets/profile/no_bank.png'),
              ),
              StyleText(
                text: 'You do not currently bind any bank card information',
                size: ScreenUtil().setWidth(16),
                color: StyleColors.defaultColor,
                textAlign: TextAlign.center,
              ),
              Container(height: 120)
            ],
          ),
        ),
      ),
    );
  }
}
