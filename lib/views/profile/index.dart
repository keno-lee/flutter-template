import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/components/dialog.dart';
import 'package:template/routers/routes.dart';
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/style/padding.dart';
import 'package:template/model/userinfo.dart';
import 'package:template/utils/format.dart';
import 'package:template/components/button.dart';
import 'package:template/routers/application.dart';

class PorfilePage extends StatefulWidget {
  // const PorfilePage({Key key}) : super(key: key);
  @override
  _PorfilePageState createState() => _PorfilePageState();
}

class _PorfilePageState extends State<PorfilePage> {
  UserInfo userInfo = UserInfo();
  _fetchData() async {
    await Future.wait([userInfo.loadData()]);
    setState(() {});
  }

  _payNow() {
    if (userInfo.infoStatus == 1)
      Application.navigateTo(context, Routes.getloan);
    else
      Application.navigateTo(context, Routes.information);
  }

  // 提现
  _withdraw() {
    if (!userInfo.login) {
      Application.navigateTo(context, Routes.login);
      return;
    }
    if (userInfo.userStatus == 0) {
      print('不是会员');
      // 不是会员，拦截去填资料或者去付钱
      CustomDialog.show(
        context,
        content:
            'You are not currently a member, you can enjoy more benefits when you become a member.',
        btnText: 'Pay Now',
        hasClose: true,
        onTap: () {
          Navigator.pop(context);
          _payNow();
        },
      );
    }
    if (userInfo.userStatus == 1) {
      // 如果金额小于10，弹窗拦截
      if (userInfo.balance < 10) {
        CustomDialog.show(
          context,
          content:
              'The current balance is less than 10, no withdrawal is posible',
          btnText: 'To Make money',
          hasClose: true,
          onTap: () {
            Navigator.pop(context);
            Application.navigateTo(context, Routes.task);
          },
        );
        return;
      }
      Application.navigateTo(
        context,
        Routes.withdraw,
        params: {'balance': userInfo.balance},
      );
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            Avatar(
              login: userInfo.login,
              avatar: userInfo.avatar,
              name: userInfo.realName,
              memberExpired: userInfo.memberExpired,
            ),
            ProfileList(
              login: userInfo.login,
              isMember: userInfo.userStatus == 1,
            ),
          ],
        ),
      ),
    );
  }
}

// 个人信息区域背景
class ProfileInfo extends StatelessWidget {
  final List<Widget> children;
  const ProfileInfo({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.bottomCenter,
      height: ScreenUtil().setWidth(240),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/profile/profile_bg.png'),
          fit: BoxFit.contain,
          alignment: Alignment.topCenter,
        ),
      ),
      // child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
      // ),
    );
  }
}

// 头像信息部分
class Avatar extends StatelessWidget {
  final bool login;
  final String avatar;
  final String name;
  final String memberExpired;

  const Avatar({
    Key key,
    this.login,
    this.avatar,
    this.name,
    this.memberExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylePadding(
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
        ),
        height: ScreenUtil().setWidth(125),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/profile/profile_bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(14)),
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/assets/profile/avatar.png'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (login) return;
                    Application.navigateTo(context, Routes.login);
                  },
                  child: StyleText(
                    text: login ? 'Hello, $name' : 'Go Login',
                    color: Colors.white,
                    size: ScreenUtil().setWidth(16),
                    opacity: 0.87,
                  ),
                ),
                login && memberExpired != ''
                    ? Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                        child: StyleText(
                          text: 'Membership is valid until $memberExpired',
                          color: Colors.white,
                          size: ScreenUtil().setWidth(11),
                          opacity: 0.87,
                        ),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 账户信息部分
class Withdraw extends StatelessWidget {
  final String balance;
  final Function withdraw;
  const Withdraw({
    Key key,
    this.balance,
    this.withdraw,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StylePadding(
      child: Container(
        // height: ScreenUtil().setWidth(110),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // image: DecorationImage(
          //   image: AssetImage('lib/assets/profile/personal_withdraw.png'),
          //   fit: BoxFit.cover,
          //   // alignment: Alignment.topCenter,
          // ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(100),
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Application.navigateTo(context, Routes.withdrawRecord);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        StyleText(
                          text: '₹${balance.toString()}',
                          color: Color(0xff0F1426),
                          size: ScreenUtil().setWidth(35),
                        ),
                        StyleText(
                          text: 'Account Balance',
                          color: Color(0xffB1B2BA),
                          size: ScreenUtil().setWidth(15),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: withdraw,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(12),
                        right: ScreenUtil().setWidth(12),
                      ),
                      alignment: Alignment.center,
                      // width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                        color: StyleColors.pirmaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: StyleText(
                        text: 'Withdraw balance',
                        color: Colors.white,
                        size: ScreenUtil().setWidth(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: ScreenUtil().setWidth(30),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       Icon(
            //         Icons.volume_up,
            //         color: Colors.white,
            //         size: ScreenUtil().setWidth(20),
            //       ),
            //       Container(width: ScreenUtil().setWidth(8)),
            //       StyleText(
            //         text:
            //             'Members can withdraw your account balance at any time',
            //         color: Colors.white,
            //         size: ScreenUtil().setWidth(10),
            //         opacity: 0.6,
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

// 个人操作列表
class ProfileList extends StatelessWidget {
  final bool login;
  final bool isMember;

  const ProfileList({
    Key key,
    this.login,
    this.isMember: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
      child: StylePadding(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              ProfileListItem(
                icon: 'lib/assets/profile/record.png',
                name: 'Loan Record',
                onTap: () {
                  if (!login) {
                    Application.navigateTo(context, Routes.login);
                    return;
                  }
                  Application.navigateTo(context, Routes.loanRecord);
                },
              ),
              ProfileListItem(
                icon: 'lib/assets/profile/bank.png',
                name: 'Bank Account',
                onTap: () {
                  if (!login) {
                    Application.navigateTo(context, Routes.login);
                    return;
                  }
                  Application.navigateTo(context, Routes.bank);
                },
              ),
              isMember
                  ? ProfileListItem(
                      icon: 'lib/assets/profile/services.png',
                      name: 'Customer Services',
                      onTap: () {
                        if (!login) {
                          Application.navigateTo(context, Routes.login);
                          return;
                        }
                        Application.navigateTo(context, Routes.customer);
                      },
                    )
                  : Container(),
              ProfileListItem(
                icon: 'lib/assets/profile/settings.png',
                name: 'Settings',
                onTap: () {
                  if (!login) {
                    Application.navigateTo(context, Routes.login);
                    return;
                  }
                  Application.navigateTo(context, Routes.settings);
                },
              ),
              ProfileListItem(
                icon: 'lib/assets/profile/privacy.png',
                name: 'Terms of service & privacy policy',
                onTap: () {
                  if (!login) {
                    Application.navigateTo(context, Routes.login);
                    return;
                  }
                  Application.navigateTo(
                    context,
                    Routes.web,
                    params: {'url': 'https://api.template6.com/protocol.html'},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileListItem extends StatelessWidget {
  final String icon;
  final String name;
  final Function onTap;
  const ProfileListItem({
    Key key,
    this.icon,
    this.name,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setWidth(65),
        // padding: EdgeInsets.only(left: 20),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(30),
              height: ScreenUtil().setWidth(30),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                // color: StyleColors.pirmaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: ScreenUtil().setWidth(16),
                height: ScreenUtil().setWidth(16),
                child: Image.asset(icon),
              ),
            ),
            StyleText(
              text: name,
              color: StyleColors.defaultColor,
              size: ScreenUtil().setWidth(16),
            ),
          ],
        ),
      ),
    );
  }
}
