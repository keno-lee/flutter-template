import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/routers/application.dart';
import 'package:template/routers/routes.dart';
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';

class GameZonePage extends StatefulWidget {
  @override
  _GameZonePageState createState() => _GameZonePageState();
}

class _GameZonePageState extends State<GameZonePage> {
  // 排序字段：sort默认sort
  String sortBy = 'sort';
  // 排序方式：ASC,DESC ，默认ASC
  String sortMethod = 'ASC';
  int page = 1;
  // 类型：1=首页推荐，2=highPassRate，3=hot，4=newProduct，5=非会员推荐，6=非会员VIP专区，7=会员Game Zone
  int cat = 7;

  List gameZoneList = [];

  _fetchGameListData() async {
    var raw = await httpUtil.get('/products', {
      'sortBy': sortBy,
      'sortMethod': sortMethod,
      'page': page,
      'cat': cat,
    });

    if (raw['status'] == 200) {
      setState(() {
        gameZoneList = raw['data'];
      });
    } else {
      showToast(raw['message']);
    }
  }

  _clickGame(id) {
    Application.navigateTo(context, Routes.taskDetail, params: {'id': id});
  }

  // 下拉刷新
  Future _onRefresh() async {
    _fetchGameListData();
    await Future.delayed(Duration(seconds: 2), () {});
  }

  @override
  void initState() {
    _fetchGameListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Game Zone',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: gameZoneList.map((item) {
              return GameZoneItem(
                id: item['product_id'],
                logo: item['product_image'],
                name: item['product_name'],
                desc: item['product_desc'],
                link: item['link'],
                onTap: _clickGame,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class GameZoneItem extends StatelessWidget {
  final num id;
  final String logo;
  final String name;
  final String desc;
  final String link;
  final Function onTap;
  const GameZoneItem({
    Key key,
    this.id,
    this.logo,
    this.name,
    this.desc,
    this.link,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(id);
      },
      child: Container(
        height: ScreenUtil().setWidth(110),
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(20),
          bottom: ScreenUtil().setWidth(20),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: StyleColors.separateColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // logo
            Container(
              alignment: Alignment.topCenter,
              width: ScreenUtil().setWidth(30),
              height: ScreenUtil().setWidth(30),
              margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(14),
              ),
              color: StyleColors.bgColor,
              child: logo != null ? Image.network(logo) : Container(),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyleText(
                            text: name,
                            size: ScreenUtil().setWidth(15),
                            color: StyleColors.defaultColor,
                          ),
                          // StyleText(
                          //   text: name,
                          //   size: ScreenUtil().setWidth(11),
                          //   color: StyleColors.defaultColor,
                          // ),
                        ],
                      ),
                      StyleText(
                        text: 'Start the game',
                        size: ScreenUtil().setWidth(15),
                        color: StyleColors.pirmaryColor,
                      ),
                    ],
                  ),
                  StyleText(
                    text:
                        'Description: Game ZoneDescription: Game ZneDescriptin: Game Zone',
                    size: ScreenUtil().setWidth(12),
                    color: StyleColors.defaultColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
