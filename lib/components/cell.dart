import 'package:flutter/material.dart';
// 引入工具
import 'package:flutter_screenutil/flutter_screenutil.dart';
// 引入样式
import '../style/text.dart';
import '../style/colors.dart';

// 单元格组件
class Cell extends StatelessWidget {
  final String title;
  final String value;
  final bool haslink;

  const Cell({
    Key key,
    this.title,
    this.value,
    this.haslink: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(42),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StyleText(
            text: title,
            color: StyleColors.tertiaryColor,
            size: ScreenUtil().setWidth(16),
          ),
          // StyleText(
          //   text: value,
          //   color: StyleColors.defaultColor,
          //   size: ScreenUtil().setWidth(16),
          // ),

          Container(
            child: Row(
              children: <Widget>[
                StyleText(
                  text: value,
                  color: StyleColors.defaultColor,
                  size: ScreenUtil().setWidth(16),
                ),
                haslink
                    ? Icon(
                        Icons.keyboard_arrow_right,
                        color: StyleColors.tertiaryColor,
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
