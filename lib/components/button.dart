import 'package:flutter/material.dart';
// 引入工具
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 引入样式
import '../style/text.dart';
import '../style/colors.dart';

class Button extends StatelessWidget {
  final String text;
  final double borderRadius;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final double textSize;
  final bool active;

  // final Widget desc;

  final Function onTap;

  const Button({
    Key key,
    this.text,
    this.borderRadius: 6,
    this.color: StyleColors.pirmaryColor,
    this.textColor: Colors.white,
    this.onTap,
    this.textSize: 18,
    this.width: 330,
    this.height: 50,
    this.active: false,
    // this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(width),
        height: ScreenUtil().setWidth(height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: active
              ? StyleColors.pirmaryColor
              : StyleColors.pirmaryDisabledColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: ScreenUtil().setWidth(textSize),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final double textSize;
  final bool active;

  // final Widget desc;

  final Function onTap;

  const GradientButton({
    Key key,
    this.text,
    this.borderRadius: 4,
    this.color: StyleColors.pirmaryColor,
    this.textColor: Colors.white,
    this.onTap,
    this.textSize: 16,
    this.width: 330,
    this.height: 45,
    this.active: false,
    // this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(width),
        height: ScreenUtil().setWidth(height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          gradient: active
              ? LinearGradient(colors: [
                  StyleColors.pirmaryGradientsStartColor,
                  StyleColors.pirmaryGradientsEndColor
                ])
              : null,
          color: !active ? StyleColors.pirmaryDisabledColor : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: ScreenUtil().setWidth(textSize),
          ),
        ),
      ),
    );
  }
}
