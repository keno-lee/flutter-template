import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
// style
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
// components
import 'package:template/components/diversion_list_item.dart';
import 'package:template/components/button.dart';
import 'package:template/components/dialog.dart';
// model
import 'package:template/model/userinfo.dart';
import 'package:template/model/deviceinfo.dart';
// tools
import 'package:template/utils/preferences.dart';
// services
import 'package:template/api/index.dart';
import 'package:template/routers/application.dart';
import 'package:template/routers/routes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserInfo userInfo = UserInfo();
  DeviceInfo deviceInfo = DeviceInfo();
  bool isLoaded = false;

  // 排序字段：sort默认sort
  String sortBy = 'sort';
  // 排序方式：ASC,DESC ，默认ASC
  String sortMethod = 'ASC';
  int page = 1;
  // 类型：1=首页推荐，2=highPassRate，3=hot，4=newProduct，5=非会员推荐，6=非会员VIP专区，7=会员Game Zone
  // int cat;

  // 会员首页列表
  List memberList = [];
  // List memberList = [
  //   {
  //     "product_id": 1,
  //     "product_type": 1,
  //     "product_name": "Long Term Loan",
  //     "product_image": "1",
  //     "product_desc": "Long Term Loan",
  //     "amount": "3000~7000",
  //     "term": "10 days",
  //     "interest": "3%",
  //     "link": "http://www.baidu.com",
  //     "link_type": 1, //1=APP内跳转，2=打开浏览器跳转
  //   }
  // ];

  // 非会员普通列表
  List unmemberNormalList = [];
  // List unmemberNormalList = [
  //   {
  //     "product_id": 1,
  //     "product_type": 1,
  //     "product_name": "Long Term Loan",
  //     "product_image": "1",
  //     "product_desc": "Long Term Loan",
  //     "amount": "3000~7000",
  //     "term": "10 days",
  //     "interest": "3%",
  //     "link": "http://www.baidu.com",
  //     "link_type": 1, //1=APP内跳转，2=打开浏览器跳转
  //   }
  // ];

  // 非会员VIP列表
  List unmemberVipList = [];
  // List unmemberVipList = [
  //   {
  //     "product_id": 1,
  //     "product_type": 1,
  //     "product_name": "Long Term Loan",
  //     "product_image": "1",
  //     "product_desc": "Long Term Loan",
  //     "amount": "3000~7000",
  //     "term": "10 days",
  //     "interest": "3%",
  //     "link": "http://www.baidu.com",
  //     "link_type": 1, //1=APP内跳转，2=打开浏览器跳转
  //   }
  // ];

  // 首页列表请求
  Future _fetchListData(cat) async {
    var raw = await httpUtil.get('/products', {
      'sortBy': sortBy,
      'sortMethod': sortMethod,
      'page': page,
      'cat': cat,
    });

    if (raw['status'] == 200) {
      return raw['data'];
    } else {
      showToast(raw['message']);
    }
  }

  Future<bool> _locationPermission() async {
    // 第一步，授权地理位置信息。如果失败了，弹窗让用户去授权
    PermissionStatus status = await Permission.location.request();
    // var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      CustomDialog.show(
        context,
        content:
            'In order to use the app normally, please authorize the location permission',
        hasClose: false,
        onTap: () async {
          Navigator.pop(context);
          await openAppSettings();
        },
      );
      return false;
    }
    return true;
  }

  // 根据地理位置等信息，后端禁用app功能
  void _uploadDeviceInfo() async {
    print('====上传设备信息');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Geolocator geolocator = Geolocator();

    var androidInfo = await deviceInfo.androidInfo;
    var packageInfo = await PackageInfo.fromPlatform();

    Position position = await geolocator.getLastKnownPosition(
      locationPermissionLevel: GeolocationPermission.locationWhenInUse,
      desiredAccuracy: LocationAccuracy.low,
    );
    // 优先获取上次的地理位置
    if (position == null) {
      position = await geolocator
          .getCurrentPosition(
            locationPermissionLevel: GeolocationPermission.locationWhenInUse,
            desiredAccuracy: LocationAccuracy.low,
          )
          .timeout(Duration(seconds: 10));
    }

    print('=====获取地理位置');
    var lang = await Prefs.localeGet('lang');
    var raw = await httpUtil.post('/device', {
      "device_id": androidInfo.androidId, // 2454269f0c893acb
      "lang": lang,
      "latitude": position != null ? position.latitude : '',
      "longitude": position != null ? position.longitude : '',
      "brand": androidInfo.brand,
      "model": androidInfo.model,
      "system": "android",
      "version": packageInfo.version,
    });

    if (raw['status'] == 500) {
      CustomDialog.show(
        context,
        content: raw['message'],
        hasClose: false,
        onTap: () {
          Navigator.pop(context);
          _uploadDeviceInfo();
        },
      );
    }
  }

  _fetchData() async {
    await userInfo.loadData();
    var token = await Prefs.getToken();
    if (token == null || token == '') {
      // 未登录不请求
      setState(() {
        isLoaded = true;
      });
      return;
    }
    // 会员状态：1=有效，-1=过期，0=未成为会员
    if (userInfo.userStatus == 1) {
      // 会员
      memberList = await _fetchListData(1);
    } else if (userInfo.userStatus == 0) {
      // 非会员（过期和填过资料）
      unmemberNormalList = await _fetchListData(5);
      unmemberVipList = await _fetchListData(6);
    }
    setState(() {
      isLoaded = true;
    });
  }

  // 更新app
  void _updateApp(link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  // 检查更新
  void _checkUpdate() async {
    await deviceInfo.loadInfo();
    var raw = await httpUtil.get('/version', {
      'v': deviceInfo.version,
      's': 'android',
    });

    // 如果需要更新，弹窗强更
    if (raw['status'] == 200 && raw['data']['update'] == 1) {
      CustomDialog.show(
        context,
        title: 'New Version Found',
        content: 'In order to ensure your normal use, please update the app',
        hasClose: false,
        onTap: () {
          _updateApp(raw['data']['url']);
        },
      );
    }
  }

  void _normalPageSubmit() async {
    bool hasPermission = await _locationPermission();
    if (!hasPermission) return;

    if (!userInfo.login) {
      // 未登录
      Application.navigateTo(context, Routes.login);
      return;
    }
    if (userInfo.infoStatus == 0) {
      // 资料未填
      Application.navigateTo(context, Routes.information);
      return;
    }
    Application.navigateTo(context, Routes.getloan);
  }

  void _normalLoanPageGetNow() {
    if (userInfo.infoStatus == 0) {
      // 资料未填
      Application.navigateTo(context, Routes.information);
      return;
    }
    Application.navigateTo(context, Routes.getloan);
  }

  @override
  void initState() {
    // _uploadDeviceInfo();
    _checkUpdate();
    _fetchData();
    super.initState();
  }

  // 下拉刷新
  Future _onRefresh() async {
    _fetchData();
    await Future.delayed(Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        // color: MyTheme.pirmaryColor,
        child: isLoaded
            ? SingleChildScrollView(
                // RefreshIndicator是根据下拉偏移量触发onRefresh操作，不能滚动自然不能下拉刷新。
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 16),
                // 没填过资料显示普通首页。是会员显示会员首页，不是会员显示非会员首页
                child: !userInfo.login || userInfo.infoStatus == 0
                    ? NormalPage(normalPageSubmit: _normalPageSubmit)
                    : userInfo.userStatus == 1
                        ? MemberLoanPage(list: memberList)
                        : NormalLoanPage(
                            list: unmemberNormalList,
                            viplist: unmemberVipList,
                            normalLoanPageGetNow: _normalLoanPageGetNow,
                          ),
              )
            : LoadingPage(),
      ),
    );
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

// 正常首页
class NormalPage extends StatelessWidget {
  final Function normalPageSubmit;
  const NormalPage({Key key, this.normalPageSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ScreenUtil().setWidth(372),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(70),
            // right: ScreenUtil().setWidth(20),
          ),
          decoration: BoxDecoration(
            // color: StyleColors.pirmaryColor,
            // borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('lib/assets/home/home_card.png'),
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StyleText(
                text: 'Maxium Loan Amount Upto',
                color: Color(0xffFFFEFE),
                size: ScreenUtil().setWidth(16),
              ),
              StyleText(
                text: '₹20000',
                color: Color(0xffFFFEFE),
                size: ScreenUtil().setWidth(58),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
          ),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16),
            right: ScreenUtil().setWidth(16),
          ),
          height: ScreenUtil().setWidth(67),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: ScreenUtil().setWidth(90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(44),
                      decoration: BoxDecoration(
                        color: Color(0xffEEECFB),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Image.asset(
                        'lib/assets/home/guide01.png',
                        width: ScreenUtil().setWidth(26),
                      ),
                    ),
                    StyleText(
                      text: 'submit info',
                      color: Color(0xff71747C),
                      size: ScreenUtil().setWidth(14),
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.keyboard_arrow_right,
              //   color: Color(0xff71747C),
              // ),
              Container(
                width: ScreenUtil().setWidth(90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(44),
                      decoration: BoxDecoration(
                        color: Color(0xffEEECFB),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Image.asset(
                        'lib/assets/home/guide02.png',
                        width: ScreenUtil().setWidth(26),
                      ),
                    ),
                    StyleText(
                      text: 'get credit',
                      color: Color(0xff71747C),
                      size: ScreenUtil().setWidth(14),
                    ),
                  ],
                ),
              ),
              // Icon(
              //   Icons.keyboard_arrow_right,
              //   color: Color(0xff71747C),
              // ),
              Container(
                width: ScreenUtil().setWidth(90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(44),
                      decoration: BoxDecoration(
                        color: Color(0xffEEECFB),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Image.asset(
                        'lib/assets/home/guide03.png',
                        width: ScreenUtil().setWidth(26),
                      ),
                    ),
                    StyleText(
                      text: 'get money',
                      color: Color(0xff71747C),
                      size: ScreenUtil().setWidth(14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(50),
            bottom: ScreenUtil().setWidth(30),
          ),
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16),
            right: ScreenUtil().setWidth(16),
          ),
          child: Button(
            text: 'Apply',
            active: true,
            onTap: normalPageSubmit,
          ),
        ),
      ],
    );
  }
}

// 普通用户贷超首页 - 未付费
class NormalLoanPage extends StatelessWidget {
  final Function normalLoanPageGetNow;
  final List list; // 普通推荐
  final List viplist; // vip推荐

  const NormalLoanPage({
    Key key,
    this.list,
    this.viplist,
    this.normalLoanPageGetNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 顶部安全距离
    return SafeArea(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: normalLoanPageGetNow,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: ScreenUtil().setWidth(228),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/home/home_normal_card.png'),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StyleText(
                        text:
                            'you currently have the following cash to collect',
                        color: Colors.white,
                        size: ScreenUtil().setWidth(11),
                        opacity: 0.7,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                StyleText(
                                  text: '₹5000',
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(28),
                                ),
                                StyleText(
                                  text: 'Loan Amount',
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(12),
                                  opacity: 0.6,
                                ),
                              ],
                            ),
                            Container(width: ScreenUtil().setWidth(46)),
                            Column(
                              children: [
                                StyleText(
                                  text: '61Days',
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(28),
                                ),
                                StyleText(
                                  text: 'Loan Term',
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(12),
                                  opacity: 0.6,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(256),
                        height: ScreenUtil().setWidth(44),
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(24),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/assets/home/home_normal_btn.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              child: Column(
                children: [
                  RecommendBox(list: list, type: 1),
                  Container(
                    height: 6,
                    color: StyleColors.bgColor,
                  ),
                  RecommendBox(list: viplist, type: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 会员贷超首页 - 付费
class MemberLoanPage extends StatelessWidget {
  final List list;

  const MemberLoanPage({Key key, this.list}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Application.navigateTo(context, Routes.more, params: {'cat': 1});
          },
          child: Container(
            height: ScreenUtil().setWidth(160),
            decoration: BoxDecoration(
              color: StyleColors.pirmaryColor,
              image: DecorationImage(
                image: AssetImage('lib/assets/home/home_vip_bg.png'),
                fit: BoxFit.contain,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Application.navigateTo(context, Routes.gamezone);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setWidth(42),
                      margin: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(10),
                      ),
                      child: Image.asset('lib/assets/home/game_zone.png'),
                    ),
                    StyleText(
                      text: 'Game zone',
                      color: StyleColors.tertiaryColor,
                      size: ScreenUtil().setWidth(12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Application.navigateTo(
                    context,
                    Routes.more,
                    params: {'cat': 3},
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setWidth(42),
                      margin: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(10),
                      ),
                      child: Image.asset('lib/assets/home/hot.png'),
                    ),
                    StyleText(
                      text: 'Hot',
                      color: StyleColors.tertiaryColor,
                      size: ScreenUtil().setWidth(12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Application.navigateTo(
                    context,
                    Routes.more,
                    params: {'cat': 4},
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setWidth(42),
                      margin: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(10),
                      ),
                      child: Image.asset('lib/assets/home/new_product.png'),
                    ),
                    StyleText(
                      text: 'New Product',
                      color: StyleColors.tertiaryColor,
                      size: ScreenUtil().setWidth(12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        RecommendBox(list: list, type: 1),
      ],
    );
  }
}

// 推荐列表
class RecommendBox extends StatefulWidget {
  // 0: 会员Recommended For You
  // 1: 非会员Recommended For You
  // 2: 非VIP Section
  final int type;
  final List list;
  RecommendBox({Key key, this.type: 0, this.list}) : super(key: key);

  @override
  _RecommendBoxState createState() => _RecommendBoxState();
}

class _RecommendBoxState extends State<RecommendBox> {
  _payNow() {
    Application.navigateTo(context, Routes.getloan);
  }

  _onTap(id, link, linkType) async {
    if (widget.type == 2) {
      // 如果是非会员，引导去开会员
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 20,
              child: Icon(Icons.close, color: Color(0xff999999)),
              alignment: Alignment.centerLeft,
            ),
          ),
          titlePadding: EdgeInsets.all(6),
          contentPadding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 16,
          ),
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Become VIP to enjoy the credit limit of this product',
                    style: TextStyle(),
                  ),
                ),
                Button(
                  onTap: _payNow,
                  text: 'Get it Now',
                  active: true,
                )
              ],
            ),
          ),
        ),
      );
      return;
    }
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

    // 埋点
    await httpUtil.post('/product/click/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          widget.type != 0
              ? Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(2)),
                  height: ScreenUtil().setWidth(44),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(4),
                        height: ScreenUtil().setWidth(20),
                        color: Colors.black,
                        margin: EdgeInsets.only(
                          right: ScreenUtil().setWidth(12),
                        ),
                      ),
                      Expanded(
                        child: StyleText(
                          text: widget.type == 2
                              ? 'VIP Section'
                              : 'Recommended For You',
                          color: StyleColors.defaultColor,
                          size: ScreenUtil().setWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.type == 0
                          ? Container(
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Application.navigateTo(
                                        context,
                                        Routes.more,
                                        params: {'cat': 1},
                                      );
                                    },
                                    child: StyleText(
                                      text: 'More',
                                      color: StyleColors.secondaryColor,
                                      size: ScreenUtil().setWidth(12),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: StyleColors.tertiaryColor,
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container(),
          Column(
            children: widget.list.map((item) {
              return DiveriosnListItem(
                id: item['product_id'],
                logo: item['product_image'],
                name: item['product_name'],
                desc: item['product_desc'],
                range: item['amount'],
                tenure: item['term'],
                interest: item['interest'],
                link: item['link'],
                linkType: item['link_type'],
                onTap: _onTap,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
