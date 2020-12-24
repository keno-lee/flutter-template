import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';

class NoFeaturePage extends StatefulWidget {
  final String title;
  const NoFeaturePage({Key key, this.title}) : super(key: key);
  @override
  _NoFeaturePageState createState() => _NoFeaturePageState();
}

class _NoFeaturePageState extends State<NoFeaturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(114),
              margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(24)),
              child: Image.asset('lib/assets/profile/waiting.png'),
            ),
            StyleText(
              text: 'The feature is waiting to be opened',
              size: ScreenUtil().setWidth(16),
              color: StyleColors.defaultColor,
            ),
          ],
        ),
      ),
    );
  }
}
