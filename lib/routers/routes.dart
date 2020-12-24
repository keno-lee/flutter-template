// import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'route_handlers.dart';

class Routes {
  static String root = "/entry";
  // 首页相关
  static String home = "/home";
  static String more = "/home/more"; // 更多列表

  /// 进件相关
  static String information = "/process/information"; // 基本资料
  static String authentication = "/process/authentication"; // 认证审核
  static String getloan = "/process/getloan"; // 购买会员

  // 任务相关
  static String task = "/task";
  static String taskDetail = "/task/detail"; // 任务详情
  static String gamezone = "/task/gamezone"; // 游戏中心
  static String upload = "/task/upload"; // 上传截图

  // 个人中心
  static String profile = "/profile";
  static String login = "/profile/login"; // 登录
  static String permissions = "/profile/permissions"; // 权限申请
  static String settings = "/profile/settings"; // 设置
  static String customer = "/profile/customer"; // 客服
  static String nofeature = "/profile/nofeature"; // 开发中的页面
  static String bank = "/profile/bank"; // 银行卡

  // 提现相关
  static String withdraw = "/withdraw"; // 提现
  static String withdrawRecord = "/withdraw/record"; // 提现记录
  static String withdrawRecordDetail = "/withdraw/record/detail"; // 提现记录详情

  // 借款相关
  static String loanRecord = "/loan/record"; // 借款记录

  // H5网页
  static String web = "/web";

  static void configureRoutes(Router router) {
    // router.notFoundHandler = Handler(
    //     handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    //   print("ROUTE WAS NOT FOUND !!!");
    // });
    router.define(root, handler: rootHandler);
    router.define(home, handler: homeHandler);
    router.define(task, handler: taskHandler);
    router.define(profile, handler: profileHandler);
    router.define(more, handler: moreHandler);
    router.define(information, handler: informationHandler);
    router.define(authentication, handler: authenticationHandler);
    router.define(getloan, handler: getloanHandler);
    router.define(taskDetail, handler: taskDetailHandler);
    router.define(gamezone, handler: gamezoneHandler);
    router.define(upload, handler: uploadHandler);
    router.define(permissions, handler: permissionsHandler);
    router.define(settings, handler: settingsHandler);
    router.define(login, handler: loginHandler);
    router.define(withdraw, handler: withdrawHandler);
    router.define(withdrawRecord, handler: withdrawRecordHandler);
    router.define(withdrawRecordDetail, handler: withdrawRecordDetailHandler);
    router.define(customer, handler: customerHandler);
    router.define(loanRecord, handler: loanRecordHandler);
    router.define(nofeature, handler: nofeatureHandler);
    router.define(bank, handler: bankHandler);
    router.define(web, handler: webHandler);
  }
}
