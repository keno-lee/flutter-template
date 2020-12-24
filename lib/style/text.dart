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

class StyleText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final fontWeight; // FontWeight.w400
  final double opacity;
  final TextOverflow overflow;
  final TextAlign textAlign;

  const StyleText({
    Key key,
    this.text,
    this.color: Colors.black,
    this.size: 12.0,
    this.fontWeight: FontWeight.normal,
    this.opacity: 1.0,
    this.overflow: TextOverflow.visible,
    this.textAlign: TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: ScreenUtil().setWidth(size),
          fontWeight: fontWeight,
          decoration: TextDecoration.none,
        ),
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}
