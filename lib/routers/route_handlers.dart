import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';

import 'package:template/main.dart';
import 'package:template/views/home/index.dart';
import 'package:template/views/home/more.dart';
import 'package:template/views/profile/index.dart';
import 'package:template/views/profile/login.dart';
import 'package:template/views/profile/permissions.dart';
import 'package:template/views/profile/nofeature.dart';
import 'package:template/views/profile/settings.dart';
import 'package:template/views/profile/customer.dart';
import 'package:template/views/loan/loan_record.dart';
import 'package:template/views/profile/bank.dart';
// 提现相关
import 'package:template/views/withdraw/withdraw.dart';
import 'package:template/views/withdraw/withdraw_record.dart';
import 'package:template/views/withdraw/withdraw_record_detail.dart';
// 进件相关
import 'package:template/views/process/getloan.dart';
import 'package:template/views/process/information.dart';
import 'package:template/views/process/authentication.dart';

import 'package:template/views/task/index.dart';
import 'package:template/views/task/detail.dart';
import 'package:template/views/task/game_zone.dart';
import 'package:template/views/task/upload.dart';

import 'package:template/views/web/index.dart';

var rootHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new EntryIndexPage();
  },
);

var homeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
  },
);

var taskHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TaskPage();
  },
);

var profileHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PorfilePage();
  },
);

var moreHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    int cat = int.parse(params['cat']?.first);
    return new HomeMorePage(cat: cat);
  },
);

var informationHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new InformationPage();
  },
);

var authenticationHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthenticationPage();
  },
);

var getloanHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GetloanPage();
  },
);

var taskDetailHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    int id = int.parse(params['id']?.first);
    return new MissionDetailPage(id: id);
  },
);

var gamezoneHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new GameZonePage();
  },
);

var uploadHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    int id = int.parse(params['id']?.first);
    int proofCount = int.parse(params['proofCount']?.first);
    return new UploadPage(id: id, proofCount: proofCount);
  },
);

var permissionsHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new PermissionsPage();
  },
);

var settingsHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new SettingsPage();
  },
);

var loginHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  },
);

var withdrawHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    int balance = int.parse(params['balance']?.first);
    return new WithdrawPage(balance: balance);
  },
);

var withdrawRecordHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new WithdrawRecordPage();
  },
);

var withdrawRecordDetailHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    int type = int.parse(params['type']?.first);
    int status = int.parse(params['status']?.first);
    String date = params['date']?.first;
    String amount = params['amount']?.first;
    String balance = params['balance']?.first;
    String source = params['source']?.first;
    String reason = params['reason']?.first;
    String serialNumber = params['serialNumber']?.first;

    return new WithdrawReocrdDetailPage(
      type: type,
      status: status,
      date: date,
      amount: amount,
      balance: balance,
      source: source,
      reason: reason,
      serialNumber: serialNumber,
    );
  },
);

var customerHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new CustomerPage();
  },
);

var loanRecordHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoanRecordPage();
  },
);

var nofeatureHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    String title = params['title']?.first;
    return new NoFeaturePage(title: title);
  },
);

var bankHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new BankPage();
  },
);

var webHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    String url = params['title']?.url;
    return new WebPage(url: url);
  },
);
