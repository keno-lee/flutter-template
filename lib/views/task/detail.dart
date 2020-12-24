import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/format.dart';
import 'package:template/utils/track.dart';
import 'package:template/routers/application.dart';
import 'package:template/components/dialog.dart';
import 'package:template/routers/routes.dart';

class MissionDetailPage extends StatefulWidget {
  final int id;
  const MissionDetailPage({Key key, this.id}) : super(key: key);
  @override
  _MissionDetailPageState createState() => _MissionDetailPageState();
}

// class IGameInfo {
//   String reward;
//   String name;
//   String image;
//   String instruction;
// }

class _MissionDetailPageState extends State<MissionDetailPage> {
  bool isLoaded = false;
  Map gameInfo = {
    'reward': 100,
    'name': '',
    'image': '',
    'instruction': '',
    'product_instruction': '',
    'proof_count': 0,
    'package_name': ''
  };
  // com.market.loanbus
  List taskStep = [];
  List _tutorialList = []; // 教程
  bool _hasThisApp = false;
  bool _openApped = false;

  String _remainingText = ''; // 按钮文案
  Timer _countdownTimer; // 倒计时定时器 30min*60s 1800s
  // 倒计时
  void _countDown(seconds) async {
    if (seconds <= 0) {
      _remainingText = '00 : 00';
      return;
    }
    if (_countdownTimer != null) {
      return;
    }
    var m;
    var s;
    m = seconds ~/ 60; // 取整 分钟
    s = seconds % 60; // 取余 秒钟
    _remainingText =
        '${m >= 10 ? m : "0" + m.toString()} : ${s >= 10 ? s : "0" + s.toString()}';
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      m = seconds ~/ 60; // 取整 分钟
      s = seconds % 60; // 取余 秒钟
      _remainingText =
          '${m >= 10 ? m : "0" + m.toString()} : ${s >= 10 ? s : "0" + s.toString()}';
      if (seconds <= 0) {
        // 回首页
        initCountDown();
      }
      setState(() {});
    });
  }

  void initCountDown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  // 请求接口
  _fetchGameDetailData() async {
    var raw = await httpUtil.get('/tasks/${widget.id}');

    if (raw['status'] == 200) {
      setState(() {
        gameInfo = raw['data'];
        taskStep = raw['data']['task_steps'];
        _tutorialList = raw['data']['tutorial'];

        var seconds = 1800 -
            (raw['data']['current_timestamp'] - raw['data']['task_started_at']);
        _countDown(seconds);

        getUsageStats();
      });
    } else {
      showToast(raw['message']);
    }
    isLoaded = true;
  }

  void getUsageStats() async {
    DateTime endDate = new DateTime.now();
    DateTime startDate =
        DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

    // grant usage permission - opens Usage Settings
    UsageStats.grantUsagePermission();

    // check if permission is granted
    bool isPermission = await UsageStats.checkUsagePermission();
    // query usage stats
    List<UsageInfo> usageStats =
        await UsageStats.queryUsageStats(startDate, endDate);
    // print('=============');
    usageStats.forEach((item) {
      if (item.packageName == gameInfo['package_name']) {
        _hasThisApp = true;
        if (int.parse(item.totalTimeInForeground) > 0) {
          _openApped = true;
        }
      }
    });
  }

  // 下载
  void _download() async {
    var link = taskStep[0]['link'];
    var linkType = taskStep[0]['link_type'];
    print(link);
    print(linkType);
    //1=APP内跳转，2=打开浏览器跳转
    if (linkType == 1) {
      Application.navigateTo(context, Routes.web, params: {'url': link});
    } else {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
    }
  }

  // 打开
  void _openApp() async {
    if (!_hasThisApp) return;
    // await LaunchApp.openApp(androidPackageName: 'com.tencent.mm');
    await LaunchApp.openApp(androidPackageName: gameInfo['package_name']);
  }

  // 接受
  void _receive() async {
    if (!_hasThisApp || !_openApped) return;

    if (gameInfo['proof_count'] == 0) {
      var options = new Options(contentType: 'application/json');

      var raw = await httpUtil.post('/tasks/submit/${widget.id}', {}, options);

      if (raw['status'] == 200) {
        CustomDialog.show(
          context,
          content:
              'Your task has been submitted for review and the review results will be available within 3 working days',
          hasClose: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        showToast(raw['message']);
      }
    } else {
      Application.navigateTo(
        context,
        Routes.upload,
        params: {'id': widget.id, 'proofCount': gameInfo['proof_count']},
      );
    }
  }

  @override
  void initState() {
    track.taskDetail();
    _fetchGameDetailData();
    super.initState();
  }

  @override
  void dispose() {
    initCountDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Container(
            // alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: StyleColors.bgColor,
              image: DecorationImage(
                image: AssetImage('lib/assets/task/mission_detail_bg.png'),
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
              appBar: AppBar(
                backgroundColor: Colors.transparent, //把appbar的背景色改成透明
                elevation: 0, //appbar的阴影
                title: Text(
                  'Mission Accomplished Get ₹${Format.formatMoney(gameInfo['reward'])} ',
                  style: TextStyle(fontSize: 14),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16),
                ),
                child: Column(
                  children: [
                    MainCard(
                      name: gameInfo['name'],
                      logo: gameInfo['image'],
                      desc: gameInfo['instruction'],
                      remainingText: _remainingText,
                    ),
                    Container(height: 10),
                    Container(
                      // height: ScreenUtil().setWidth(125),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        right: ScreenUtil().setWidth(15),
                        top: ScreenUtil().setWidth(15),
                        bottom: ScreenUtil().setWidth(18),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyleText(
                            // 'Task instruodutions:173 remaining  Product int-roduction ProdTask instruodutions.'
                            text:
                                '${gameInfo['product_instruction'] ?? gameInfo['product_instruction']}',
                            color: StyleColors.tertiaryColor,
                            size: ScreenUtil().setWidth(15),
                          ),
                          Container(
                            height: ScreenUtil().setWidth(25),
                          ),
                          StyleText(
                            text: 'Task steps:',
                            color: StyleColors.defaultColor,
                            size: ScreenUtil().setWidth(18),
                          ),
                          MyStep(
                            step: 1,
                            buttonText: taskStep[0]['button_text'],
                            content: taskStep[0]['description'],
                            active: true,
                            onTap: _download,
                          ),
                          MyStep(
                            step: 2,
                            buttonText: taskStep[1]['button_text'],
                            content: taskStep[1]['description'],
                            active: _hasThisApp,
                            onTap: _openApp,
                          ),
                          MyStep(
                            step: 3,
                            buttonText: taskStep[2]['button_text'],
                            content: taskStep[2]['description'],
                            active: _hasThisApp && _openApped,
                            onTap: _receive,
                          ),
                        ],
                      ),
                    ),
                    Container(height: 10),
                    TutorialPart(
                      tutorialList: _tutorialList,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(body: LoadingPage());
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(color: StyleColors.pirmaryColor),
    );
  }
}

class MainCard extends StatelessWidget {
  final String logo;
  final String name;
  final String desc;
  final String remainingText;
  const MainCard({
    Key key,
    this.logo,
    this.name: '',
    this.desc: '',
    this.remainingText: '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: ScreenUtil().setWidth(125),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(14),
        right: ScreenUtil().setWidth(14),
        top: ScreenUtil().setWidth(18),
        bottom: ScreenUtil().setWidth(11),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: ScreenUtil().setWidth(30),
                height: ScreenUtil().setWidth(30),
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(7)),
                child: logo != null
                    ? CircleAvatar(backgroundImage: NetworkImage(logo))
                    : Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyleText(
                    text: '$name',
                    color: StyleColors.defaultColor,
                    size: ScreenUtil().setWidth(18),
                  ),
                  StyleText(
                    text: 'Remaining : $remainingText',
                    color: StyleColors.tertiaryColor,
                    size: ScreenUtil().setWidth(11),
                  ),
                ],
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 8),
            child: StyleText(
              text: '$desc',
              color: StyleColors.tertiaryColor,
              size: ScreenUtil().setWidth(15),
            ),
          ),
        ],
      ),
    );
  }
}

class MyStep extends StatelessWidget {
  final int step; // 第几步骤
  final String content; // 内容
  final String buttonText;
  final bool active; // 按钮激活
  final Function onTap;

  const MyStep({
    Key key,
    this.step,
    this.content: '',
    this.active: false,
    this.buttonText: '',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StyleText(
                  text: 'Step$step ',
                  color: StyleColors.defaultColor,
                  size: ScreenUtil().setWidth(15),
                ),
                Container(
                  width: ScreenUtil().setWidth(160),
                  child: StyleText(
                    text: '$content',
                    color: StyleColors.defaultColor,
                    size: ScreenUtil().setWidth(15),
                  ),
                ),
              ],
            ),
            StyleText(
              text: '$buttonText',
              color:
                  active ? StyleColors.pirmaryColor : StyleColors.defaultColor,
              size: ScreenUtil().setWidth(15),
            ),
          ],
        ),
      ),
    );
  }
}

class TutorialPart extends StatelessWidget {
  final List tutorialList;
  const TutorialPart({Key key, this.tutorialList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tutorialList.length <= 0
        ? Container()
        : Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setWidth(13),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setWidth(50),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(16),
                  ),
                  child: StyleText(
                    text: 'Detailed Tutorial',
                    color: StyleColors.defaultColor,
                    size: ScreenUtil().setWidth(18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(16),
                    right: ScreenUtil().setWidth(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: StyleText(
                          text:
                              'A total of ${tutorialList.length} steps tutorial, Click on the picture to view',
                          color: Color(0xff333333),
                          size: ScreenUtil().setWidth(11),
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: tutorialList.map((item) {
                          return PhotoItem(image: item);
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

class PhotoItem extends StatelessWidget {
  final String image;
  const PhotoItem({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => Center(
              child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                height: 40,
                color: Colors.black,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: PhotoView(
                  imageProvider: NetworkImage(image),
                ),
              ),
            ],
          )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 16),
        width: ScreenUtil().setWidth(90),
        height: ScreenUtil().setWidth(90),
        child: Image.network(image),
      ),
    );
  }
}
