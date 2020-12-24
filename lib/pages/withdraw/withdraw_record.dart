import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/routers/routes.dart';
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/format.dart';
import 'package:template/style/padding.dart';
import 'package:template/routers/application.dart';

// class RecordListInfo {
//   Future loadData() async {
//     var raw = await httpUtil.get('/balance/transactions', {
//       'page': 1,
//       'limit': 20,
//     });
//     print(raw);
//     list = raw['data']['transactions'];
//   }

//   List<RecordListItemInfo> list = [];
// }

// class RecordListItemInfo {
//   int id;
//   int type; // 交易类型
//   int status; // 状态
//   int amount; // 交易金额 单位: 分
//   int balance; // 交易完成后账户余额 单位: 分
//   String finish_at; // 交易完成时间
//   String source; // 交易发起原因
//   String reason; // 交易失败原因
//   String serial_number;
// }

class WithdrawRecordPage extends StatefulWidget {
  @override
  _WithdrawRecordPageState createState() => _WithdrawRecordPageState();
}

class _WithdrawRecordPageState extends State<WithdrawRecordPage> {
  List recordList = [
    // {
    //   "id": 1,
    //   "type": 1, // 交易类型: 1: 任务奖励;  2: 提现
    //   "status": 0, // 交易状态: 0: 处理中; 1: 成功; 2: 失败
    //   "amount": 200000, // 交易金额 单位: 分
    //   "balance": 300000, // 交易完成后账户余额 单位: 分
    //   "finish_at": "2020-01-01 12:00:00", // 交易完成时间
    //   "source": "paytm (0012)", // 交易发起原因
    //   "reason": "account error", // 交易失败原因
    //   "serial_number": "T21980938210830182819801" // 交易流水号
    // },
    // {
    //   "id": 2,
    //   "type": 2, // 交易类型: 1: 任务奖励;  2: 提现
    //   "status": 1, // 交易状态: 0: 处理中; 1: 成功; 2: 失败
    //   "amount": 200000, // 交易金额 单位: 分
    //   "balance": 300000, // 交易完成后账户余额 单位: 分
    //   "finish_at": "2020-01-01 12:00:00", // 交易完成时间
    //   "source": "paytm (0012)", // 交易发起原因
    //   "reason": "account error", // 交易失败原因
    //   "serial_number": "T21980938210830182819801" // 交易流水号
    // },
    // {
    //   "id": 3,
    //   "type": 2, // 交易类型: 1: 任务奖励;  2: 提现
    //   "status": 2, // 交易状态: 0: 处理中; 1: 成功; 2: 失败
    //   "amount": 200000, // 交易金额 单位: 分
    //   "balance": 300000, // 交易完成后账户余额 单位: 分
    //   "finish_at": "2020-01-01 12:00:00", // 交易完成时间
    //   "source": "paytm (0012)", // 交易发起原因
    //   "reason": "account error", // 交易失败原因
    //   "serial_number": "T21980938210830182819801" // 交易流水号
    // }
  ];

  _fetchRecordData() async {
    var raw = await httpUtil.get('/balance/transactions', {
      'page': 1,
      'limit': 20,
    });
    setState(() {
      recordList = raw['data']['transactions'];
    });
  }

  @override
  void initState() {
    _fetchRecordData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Balance Record',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: recordList.length <= 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(114),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(24)),
                    child: Image.asset('lib/assets/task/nolist.png'),
                  ),
                  StyleText(
                    text: 'There is no record of withdrawal',
                    size: ScreenUtil().setWidth(16),
                    color: StyleColors.defaultColor,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: recordList.map((item) {
                  return WithdrawItem(
                    type: item['type'],
                    date: item['finish_at'],
                    amount: Format.formatMoney(item['amount']),
                    balance: Format.formatMoney(item['balance']),
                    status: item['status'],
                    source: item['source'],
                    reason: item['reason'],
                    serialNumber: item['serial_number'],
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class WithdrawItem extends StatelessWidget {
  final int type;
  final int status;
  final String date;
  final String amount;
  final String balance; // Make Money / Withdraw

  final String source;
  final String reason;
  final String serialNumber;

  const WithdrawItem({
    Key key,
    this.type,
    this.status,
    this.date,
    this.amount,
    this.balance,
    this.source,
    this.reason,
    this.serialNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Application.navigateTo(
          context,
          Routes.withdrawRecordDetail,
          params: {
            'type': type,
            'status': status,
            'date': date,
            'amount': amount,
            'balance': balance,
            'source': source,
            'reason': reason,
            'serialNumber': serialNumber,
          },
        );
      },
      child: Container(
        height: ScreenUtil().setWidth(76),
        // padding: EdgeInsets.only(
        //   top: ScreenUtil().setWidth(20),
        //   bottom: ScreenUtil().setWidth(20),
        // ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: StyleColors.separateColor),
          ),
        ),
        child: StylePadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      StyleText(
                        text: type == 1 ? 'Make Money' : 'Withdraw',
                        color: StyleColors.defaultColor,
                        size: ScreenUtil().setWidth(15),
                      ),
                      ProcessTag(process: status),
                    ],
                  ),
                  StyleText(
                    // text: '+600.00',
                    text: '${type == 1 ? '+' : '-'} ₹$amount',
                    color: status == 2
                        ? Color(0xff999999)
                        : type == 1
                            ? Color(0xffFF3A3A)
                            : Color(0xff333333),
                    size: ScreenUtil().setWidth(15),
                  ),
                ],
              ),
              Container(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StyleText(
                    // text: '02/10/2020 20:12',
                    text: date,
                    color: StyleColors.tertiaryColor,
                    size: ScreenUtil().setWidth(11),
                  ),
                  StyleText(
                    // text: 'Account Balance: ₹ 3200.00',
                    text: 'Account Balance: ₹ $balance',
                    color: StyleColors.tertiaryColor,
                    size: ScreenUtil().setWidth(11),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProcessTag extends StatelessWidget {
  // status: 交易状态: 0: 处理中; 1: 成功; 2: 失败
  final int process; // 0失败 1完成中 2审核中 3已完成
  const ProcessTag({Key key, this.process}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return process == 1
        ? Container()
        : Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
            child: StyleText(
              text: process == 0 ? 'Under Review' : 'failed',
              size: ScreenUtil().setWidth(12),
              color: process == 0 ? Color(0xff1B9CFF) : Color(0xffCCCCCC),
            ),
          );
  }
}
