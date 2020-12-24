import 'package:flutter/material.dart';
// 引入工具
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/routers/application.dart';
import 'package:template/routers/routes.dart';
// 引入样式
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
// 引入组件
import 'package:template/components/cell.dart';
import 'package:template/components/diversion_list_item.dart';
import 'package:template/routers/application.dart';

class DebugPage extends StatefulWidget {
  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Debug page',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TestItem(
              page: 'Login',
              url: Routes.login,
            ),
            TestItem(
              page: 'Balance Record',
              url: Routes.withdrawRecord,
            ),
            TestItem(
              page: 'Get Loan',
              url: Routes.getloan,
            ),
            TestItem(
              page: 'Mission Detail',
              url: Routes.taskDetail,
            ),
            TestItem(
              page: 'Permissions',
              url: Routes.permissions,
            ),
            TestItem(
              page: 'Personal Information',
              url: Routes.information,
            ),
            TestItem(
              page: 'More',
              url: Routes.more,
              params: {'cat': 4},
            ),
            TestItem(
              page: 'Game Zone',
              url: Routes.gamezone,
            ),
            TestItem(
              page: 'Authentication',
              url: Routes.authentication,
            ),
            TestItem(
              page: 'Upload',
              url: Routes.upload,
              params: {'id': 1, 'proofCount': 4},
            ),
            TestItem(
              page: 'NoFeaturePage',
              url: Routes.nofeature,
              params: {'title': 'NoFeaturePage'},
            ),
            TestItem(
              page: 'Withdraw',
              url: Routes.withdraw,
              params: {'balance': 20000},
            ),
            TestItem(
              page: 'customer',
              url: Routes.customer,
            ),
            TestItem(
              page: 'Loan Record',
              url: Routes.loanRecord,
            ),
            TestItem(
              page: 'Bank',
              url: Routes.bank,
            ),
          ],
        ),
      ),
    );
  }
}

class TestItem extends StatelessWidget {
  final String page;
  final String url;
  final Map<String, dynamic> params;
  const TestItem({Key key, this.page, this.url: '', this.params})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Application.navigateTo(context, url, params: params);
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        color: Colors.cyanAccent,
        child: Text(page),
      ),
    );
  }
}
