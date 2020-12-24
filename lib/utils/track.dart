import 'package:appsflyer_sdk/appsflyer_sdk.dart';

Track track = new Track();

class Track {
  // String REGISTER = "af_complete_registration";
  String REGISTER = "af_new";
  String LOGIN = "af_login";
  String PAY_CLICK = "af_purchase";
  String PAY_CANCEL = "af_canceled_purchase";
  String PERSONAL_INFO_UPDATE = "af_update";
  String Task_Detail = "af_mission";

  static Track instance;

  AppsflyerSdk _appsflyerSdk;
  AppsFlyerOptions options;

  Track() {
    options = AppsFlyerOptions(
      afDevKey: "UidPUG9AbHu5nBPnYMrFwH",
      showDebug: true,
    );
    _appsflyerSdk = AppsflyerSdk(options);
    _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );
  }

  static Track getInstance() {
    if (null == instance) instance = new Track();
    return instance;
  }

  Future _sendEvent(String eventName) async {
    Map eventValues = {'value': ''};
    bool result;
    try {
      // result = await _appsflyerSdk.logEvent(eventName, eventValues);
      result = await _appsflyerSdk.trackEvent(eventName, eventValues);
    } on Exception catch (e) {
      print("logEvent Error: $e");
    }
    print("logEvent: $eventName ; Result: $result");
  }

  ///登录后根据返回字段`is_new`为1的时候调用
  register() => _sendEvent(REGISTER);

  ///每次验证码验证后调用
  login() => _sendEvent(LOGIN);

  ///每次在调起支付界面前调用
  payClick() => _sendEvent(PAY_CLICK);

  ///从支付界面点击取消后调用
  payCancel() => _sendEvent(PAY_CANCEL);

  ///个人信息填写后调用
  personalInfoUpdate() => _sendEvent(PERSONAL_INFO_UPDATE);

  ///任务中心页面PV
  taskDetail() => _sendEvent(Task_Detail);
}
