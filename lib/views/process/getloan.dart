import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';
import 'package:template/model/deviceinfo.dart';
import 'package:template/utils/preferences.dart';
import 'package:template/utils/format.dart';
import 'package:template/components/dialog.dart';
import 'package:template/utils/track.dart';
import 'package:template/routers/routes.dart';

class GetloanPage extends StatefulWidget {
  @override
  _GetloanPageState createState() => _GetloanPageState();
}

class _GetloanPageState extends State<GetloanPage> {
  DeviceInfo deviceInfo = DeviceInfo();
  Razorpay _razorpay = Razorpay();

  List amountList = [5000, 10000, 20000, 50000, 100000];
  List termList = [61, 90, 120, 180, 360];
  int amountSelectedIndex = 1; // 默认5000
  int termSelectedIndex = 0;

  num interest = 0;
  num repayment = 0;
  num fee = 0;

  String orderId;

  String _remainingText = ''; // 按钮文案
  Timer _countdownTimer; // 倒计时定时器 30min*60s 1800s
  // 倒计时
  void _countDown(seconds) async {
    var res = await Prefs.localeGet('getloan');
    if (res != null) return; // 如果进来过就不再倒计时
    Prefs.localeSet('getloan', '1'); // 代表进来过来，不再倒计时
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
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.root,
          (route) => route == null,
        );
      }
      setState(() {});
    });
  }

  void initCountDown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  // 立即付款
  _borrowNow() async {
    // 加载一个动画
    showDialog(
      // 点击阴影是否关闭
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
              width: 160,
              height: 120,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitFadingCircle(
                    color: StyleColors.pirmaryColor,
                    size: 50.0,
                  ),
                  Container(height: 20),
                  Text(
                    'Waiting...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff333333),
                      decoration: TextDecoration.none,
                    ),
                  )
                ],
              )),
        );
      },
    );
    // 先调用后端支付接口，拿到options。然后请求SDK
    await deviceInfo.loadInfo();
    // return;

    var raw = await httpUtil.post('/razorpay/payCheck', {
      // 支付发起位置 支付页面发起 from=paymentPage,支付返回的弹框发起 from=retryButton,非会员页上面按钮发起 from=trialTopButton,非会员页下面弹框发起 from=trialToastButton 提现页面发起from=withdraw
      "from": 'paymentPage',
      "appsflyer_id": 'af_purchase', // 点击支付
      // advertising_id	是	string	优先gaid, 拿不到的话就取android id
      "advertising_id": deviceInfo.androidId,
      "ip": "",
      "principle": amountList[amountSelectedIndex] * 100,
      "days": termList[termSelectedIndex],
      "fee": fee,
    });

    if (raw['status'] == 200) {
      // {amount: 29900, currency: INR, key: rzp_test_mJKM1Sd4BnC7pm, name: CreditLoan, order_id: order_FMeerumHFyOz1O, prefill: {contact: 1234567891, email: kebuuba@qq.com, name: 1}}
      //  var options = {
      //     'key': raw['data'][],
      //     'amount': 100,
      //     'name': 'Acme Corp.',
      //     'description': 'Fine T-Shirt',
      //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
      //   };
      try {
        track.payClick();
        _razorpay.open(raw['data']);
      } catch (e) {
        print('error');
      }
      setState(() {
        orderId = raw['data']['order_id'];
      });
    } else {
      showToast(raw['message']);
    }
  }

  // 计算价格
  _fetchCalculate() async {
    var raw = await httpUtil.post('/fee/calculate', {
      "principle": amountList[amountSelectedIndex] * 100, // 借款金额: 单位分
      "days": termList[termSelectedIndex], // 借款天数
    });

    if (raw['status'] == 200) {
      setState(() {
        interest = raw['data']['interest'];
        repayment = raw['data']['repayment'];
        fee = raw['data']['fee'];
      });
    } else {
      showToast(raw['message']);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Navigator.pop(context); // 关闭动画

    // Do something when payment succeeds
    var raw = await httpUtil.post('/razorpay/paymentCallback', {
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
      "is_cancel": 0
    });

    if (raw['status'] == 200) {
      // 完成后点击OK回到首页
      CustomDialog.show(
        context,
        title: 'Congratulations!',
        content:
            'Your credit score: 968 And we have matched the loan products for you.',
        hasClose: false,
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.root,
            (route) => route == null,
          );
        },
      );
    } else {
      showToast(raw['message']);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    // print(response.code);
    // print(response.message);
    // code
    // NETWORK_ERROR = 0;
    // INVALID_OPTIONS = 1;
    // PAYMENT_CANCELLED = 2;
    // TLS_ERROR = 3;
    // INCOMPATIBLE_PLUGIN = 4;
    // UNKNOWN_ERROR = 100;
    Navigator.pop(context); // 关闭动画

    if (response.code == 2) {
      track.payCancel();

      CustomDialog.show(
        context,
        content:
            'You are only one step away from getting the credit score and loan amount.',
        hasClose: true,
        btnText: 'Receive',
        close: () async {
          var raw = await httpUtil.post('/razorpay/paymentCallback', {
            "razorpay_order_id": orderId,
            "is_cancel": 1,
          });

          if (raw['status'] == 200) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.root,
              (route) => route == null,
            );
          } else {
            showToast(raw['message']);
          }
        },
        onTap: () {
          Navigator.pop(context);
        },
      );
    } else {
      showToast(response.message);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Navigator.pop(context); // 关闭动画
  }

  // 离开页面
  _showDetainDialog() {
    CustomDialog.show(
      context,
      content: 'Become a VIP to enjoy the credit limit of this product',
      btnText: 'Receive',
      hasClose: true,
      close: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.root,
          (route) => route == null,
        );
      },
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchCalculate();
    _countDown(1800); // 30min
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    initCountDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showDetainDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Get Loan',
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false, //设置没有返回按钮
          centerTitle: true,
          backgroundColor: StyleColors.pirmaryColor,
          elevation: 0,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(16),
                        left: ScreenUtil().setWidth(16),
                        right: ScreenUtil().setWidth(16),
                      ),
                      color: StyleColors.pirmaryColor,
                      child: Column(
                        children: [
                          // Loan Amount
                          Container(
                            alignment: Alignment.centerLeft,
                            height: ScreenUtil().setWidth(50),
                            child: StyleText(
                              text: 'Loan Amount(₹)',
                              color: Colors.white,
                              size: ScreenUtil().setWidth(15),
                              opacity: 0.6,
                            ),
                          ),
                          Container(
                            height: ScreenUtil().setWidth(30),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: amountList.asMap().keys.map((index) {
                                return SelectCircle(
                                  onTap: () {
                                    setState(() {
                                      amountSelectedIndex = index;
                                      _fetchCalculate();
                                    });
                                  },
                                  value: amountList[index].toString(),
                                  active: index == amountSelectedIndex,
                                );
                              }).toList(),
                            ),
                          ),
                          // Term
                          Container(
                            alignment: Alignment.centerLeft,
                            height: ScreenUtil().setWidth(50),
                            child: StyleText(
                              text: 'Term(day)',
                              color: Colors.white,
                              size: ScreenUtil().setWidth(15),
                              opacity: 0.6,
                            ),
                          ),
                          Container(
                            height: ScreenUtil().setWidth(30),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: termList.asMap().keys.map((index) {
                                return SelectCircle(
                                  onTap: () {
                                    setState(() {
                                      termSelectedIndex = index;
                                      _fetchCalculate();
                                    });
                                  },
                                  value: termList[index].toString(),
                                  active: index == termSelectedIndex,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // detail
                    Container(
                      child: Container(
                        padding: EdgeInsets.only(
                          // top: ScreenUtil().setWidth(20),
                          left: ScreenUtil().setWidth(16),
                          right: ScreenUtil().setWidth(16),
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(10),
                        //     topRight: Radius.circular(10),
                        //   ),
                        // ),
                        child: DetailPart(
                          disbursal: amountList[amountSelectedIndex].toString(),
                          interest: Format.formatMoney(interest),
                          repayment: Format.formatMoney(repayment),
                          fee: Format.formatMoney(fee),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 18),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(16),
                        right: ScreenUtil().setWidth(16),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(12),
                          right: ScreenUtil().setWidth(12),
                          top: ScreenUtil().setWidth(12),
                          bottom: ScreenUtil().setWidth(12),
                        ),
                        color: Color(0xffFEFCED),
                        child: StyleText(
                          text:
                              'You can purchase the service fee ,and we will increase your loan credit score and determine your loan eligibility.',
                          color: Color(0xffFF7228),
                          size: ScreenUtil().setWidth(11),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(height: ScreenUtil().setWidth(20)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(12),
                bottom: ScreenUtil().setWidth(10),
              ),
              child: GestureDetector(
                onTap: _borrowNow,
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(330),
                  height: ScreenUtil().setWidth(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: StyleColors.pirmaryColor,
                  ),
                  child: _remainingText != ''
                      ? Text(
                          '$_remainingText Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setWidth(16),
                          ),
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setWidth(16),
                          ),
                        ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                // color: Color(0xffFBF4FE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPart extends StatelessWidget {
  final String disbursal;
  final String interest;
  final String repayment;
  final String fee;
  const DetailPart({
    Key key,
    this.disbursal,
    this.interest,
    this.repayment,
    this.fee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          DetailPartItem(title: 'Disbursal', value: '₹$disbursal'),
          DetailPartItem(title: 'Interest', value: '₹$interest'),
          DetailPartItem(title: 'Repayment', value: '₹$repayment'),
          DetailPartItem(title: 'Service Fee', value: '₹$fee'),
        ],
      ),
    );
  }
}

class DetailPartItem extends StatelessWidget {
  final String title;
  final String value;
  const DetailPartItem({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(55),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: StyleColors.separateColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          StyleText(
            text: title,
            color: StyleColors.tertiaryColor,
            size: ScreenUtil().setWidth(16),
          ),
          StyleText(
            text: value,
            color: StyleColors.defaultColor,
            size: ScreenUtil().setWidth(16),
          ),
        ],
      ),
    );
  }
}

class SelectCircle extends StatelessWidget {
  final String value;
  final bool active;
  final Function onTap;
  const SelectCircle({
    Key key,
    this.onTap,
    this.value,
    this.active: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(70),
        height: ScreenUtil().setWidth(32),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: active ? Color(0xffFFA03C) : Colors.white,
        ),
        child: StyleText(
          text: value,
          color: active ? Colors.white : StyleColors.pirmaryColor,
          size: ScreenUtil().setWidth(15),
        ),
      ),
    );
  }
}
