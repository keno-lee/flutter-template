import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/routers/routes.dart';
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/components/button.dart';
import 'package:template/utils/preferences.dart';

class PermissionsPage extends StatefulWidget {
  @override
  _PermissionsPageState createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permissions',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StyleText(
                    text: 'HI,',
                    size: ScreenUtil().setWidth(16),
                    color: StyleColors.secondaryColor,
                  ),
                  StyleText(
                    text:
                        'To access your eligibility and facilitate faster disbursal of your loan,we need these permissions',
                    size: ScreenUtil().setWidth(16),
                    color: StyleColors.secondaryColor,
                  ),
                  PermissionsItem(
                    name: '1. Storage',
                    desc:
                        'By continuing you agree to our Terms of Service & Privacy Policy and receive communication from Rupeewallet via SMS and E-mail.',
                  ),
                  PermissionsItem(
                    name: '2. Location',
                    desc:
                        'By continuing you agree to our Terms of Service & Privacy Policy and receive communication from Rupeewallet via SMS and E-mail.',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Button(
              text: 'OK',
              active: true,
              onTap: () {
                Prefs.localeSet('permissions', '1');
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.root,
                  (route) => route == null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PermissionsItem extends StatelessWidget {
  final String name;
  final String desc;

  const PermissionsItem({Key key, this.name, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StyleText(
            text: name,
            size: ScreenUtil().setWidth(12),
            color: StyleColors.tertiaryColor,
          ),
          StyleText(
            text: desc,
            size: ScreenUtil().setWidth(12),
            color: StyleColors.tertiaryColor,
          ),
        ],
      ),
    );
  }
}
