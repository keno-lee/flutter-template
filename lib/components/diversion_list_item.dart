import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/colors.dart';
import '../style/text.dart';

class DiveriosnListItem extends StatelessWidget {
  final int id;
  final int type; // 0 首页样式 1 more样式
  final String logo;
  final String name;
  final String desc;
  final String range;
  final String tenure;
  final String link;
  final int linkType; //1=APP内跳转，2=打开浏览器跳转

  final String interest;
  final Function onTap;

  const DiveriosnListItem({
    Key key,
    this.id,
    this.type = 0,
    this.logo,
    this.name,
    this.desc,
    this.range,
    this.tenure,
    this.interest,
    this.onTap,
    this.link,
    this.linkType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(id, link, linkType);
      },
      child: Container(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(16),
          left: ScreenUtil().setWidth(14),
          right: ScreenUtil().setWidth(14),
        ),
        // color: Colors.red,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: StyleColors.separateColor),
          ),
        ),
        child: Column(
          children: <Widget>[
            // 产品信息区域
            Container(
              height: ScreenUtil().setWidth(30),
              // color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 产品logo+name信息
                  Expanded(
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setWidth(30),
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(14),
                            ),
                            color: StyleColors.bgColor,
                            child: logo != null
                                ? Image.network(logo)
                                : Container(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              StyleText(
                                text: name,
                                size: ScreenUtil().setWidth(14),
                                color: StyleColors.defaultColor,
                              ),
                              StyleText(
                                text: desc,
                                size: ScreenUtil().setWidth(10),
                                color: StyleColors.tertiaryColor,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // 点击借款 LOAN NOW
                  Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      // gradient: LinearGradient(colors: [
                      //   StyleColors.pirmaryGradientsStartColor,
                      //   StyleColors.pirmaryGradientsEndColor
                      // ]),
                      // border: Border.all(
                      //   width: 1,
                      //   color: StyleColors.pirmaryColor,
                      // ),
                      color: StyleColors.pirmaryColor,
                    ),
                    alignment: Alignment.center,
                    child: StyleText(
                      text: 'LOAN NOW',
                      color: Colors.white,
                      size: ScreenUtil().setWidth(11),
                    ),
                  )
                ],
              ),
            ),
            // 产品描述区
            Container(
              height: ScreenUtil().setWidth(60),
              // color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      StyleText(
                        text: range,
                        size: ScreenUtil().setWidth(12),
                        color: Color(0xFFFF3811),
                      ),
                      Container(height: ScreenUtil().setWidth(2)),
                      StyleText(
                        text: 'RANGE',
                        size: ScreenUtil().setWidth(10),
                        color: StyleColors.weakenColor,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StyleText(
                        text: tenure,
                        size: ScreenUtil().setWidth(12),
                        color: Colors.black,
                      ),
                      Container(height: ScreenUtil().setWidth(2)),
                      StyleText(
                        text: 'LOAN TENURE',
                        size: ScreenUtil().setWidth(10),
                        color: StyleColors.weakenColor,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      StyleText(
                        text: interest,
                        size: ScreenUtil().setWidth(12),
                        color: Colors.black,
                      ),
                      Container(height: ScreenUtil().setWidth(2)),
                      StyleText(
                        text: 'INTEREST',
                        size: ScreenUtil().setWidth(10),
                        color: StyleColors.weakenColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
