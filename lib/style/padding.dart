import 'package:flutter/material.dart';
// 引入工具
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './colors.dart';

// demo
// StyleText(
//   text: '₹ 20000',
//   color: Color(0xffFFFEFE),
//   size: ScreenUtil().setWidth(60),
// ),
class StylePadding extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;

  const StylePadding({
    Key key,
    this.child,
    this.margin,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(16),
        right: ScreenUtil().setWidth(16),
      ),
      child: child,
    );
  }
}
