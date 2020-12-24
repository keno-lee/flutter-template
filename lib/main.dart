import 'package:flutter/material.dart' hide Router;
// 引入样式
import './style/colors.dart';
// 引入页面
import './pages/home/index.dart';
import './pages/task/index.dart';
import './pages/debug/index.dart';
import './pages/profile/index.dart';
// 引入工具
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/utils/preferences.dart';
import './pages/profile/permissions.dart';
import 'package:disable_screenshots/disable_screenshots.dart';

import 'package:fluro/fluro.dart';
import 'package:template/routers/routes.dart';
import 'package:template/routers/application.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.bottom,
      textPadding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: MaterialApp(
        title: 'template',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(primaryColor: StyleColors.pirmaryColor),
        onGenerateRoute: Application.router.generator,
        home: EntryIndexPage(),
        // ignore: missing_return
        localeResolutionCallback: (locale, supportedLocales) {
          Prefs.localeSet('lang', locale.toLanguageTag());
        },
      ),
    );
  }
}

// 入口页面
class EntryIndexPage extends StatefulWidget {
  _EntryIndexPageState createState() => _EntryIndexPageState();
}

class _EntryIndexPageState extends State<EntryIndexPage> {
  DisableScreenshots _plugin = DisableScreenshots();
  int currentIndex = 0; // 当前索引
  Widget currentPage; // 当前页面
  bool permissions = true; // 是否点击过权限同意

  // tabbar内容主体
  final List<Widget> tabBodies = [
    HomePage(),
    TaskPage(),
    PorfilePage(),
    // DebugPage(),
  ];

  // 判断是否需要权限告知页
  _needPermissionsPage() async {
    var res = await Prefs.localeGet('permissions');
    // await Prefs.localeRemove('permissions');
    permissions = res != '' ? true : false;
    setState(() {});
  }

  @override
  void initState() {
    _plugin.disableScreenshots(true); // 禁用截屏
    _needPermissionsPage();

    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 360, height: 640); // 初始化屏幕自适应
    return permissions
        ? Scaffold(
            backgroundColor: StyleColors.bgColor,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: [
                BottomNavigationBarItem(
                  // title: Text('Loan'),
                  label: 'Loan',
                  icon: _BottomItemIcon(url: 'lib/assets/entry/home.png'),
                  activeIcon: _BottomItemIcon(
                    url: 'lib/assets/entry/home-active.png',
                  ),
                ),
                BottomNavigationBarItem(
                  // title: Text('Repayment'),
                  label: 'Repayment',
                  icon: _BottomItemIcon(url: 'lib/assets/entry/task.png'),
                  activeIcon: _BottomItemIcon(
                    url: 'lib/assets/entry/task-active.png',
                  ),
                ),
                BottomNavigationBarItem(
                  // title: Text('Profile'),
                  label: 'Profile',
                  icon: _BottomItemIcon(url: 'lib/assets/entry/profile.png'),
                  activeIcon: _BottomItemIcon(
                    url: 'lib/assets/entry/profile-active.png',
                  ),
                ),
                // BottomNavigationBarItem(
                //   // title: Text('Debug'),
                //   label: 'Debug',
                //   icon: Icon(Icons.bug_report),
                //   activeIcon: Icon(Icons.bug_report),
                // ),
              ],
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  currentPage = tabBodies[currentIndex];
                });
              },
            ),
            body: IndexedStack(
              index: currentIndex,
              children: tabBodies,
            ),
          )
        : PermissionsPage();
  }

  Widget bottomItemIcon(url) {
    return Image.asset(
      url,
      width: ScreenUtil().setWidth(40),
      height: ScreenUtil().setWidth(40),
    );
  }
}

// 底部按钮图标widget
class _BottomItemIcon extends StatelessWidget {
  final String url;
  const _BottomItemIcon({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      url,
      width: ScreenUtil().setWidth(20),
      height: ScreenUtil().setWidth(18),
    );
  }
}
