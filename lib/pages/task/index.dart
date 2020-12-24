import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Loan Record',
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
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setWidth(155),
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(24)),
                child: Image.asset('lib/assets/profile/no_loanrecord.png'),
              ),
              StyleText(
                text: 'You do not currently have any loan records',
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
