import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/routers/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/components/diversion_list_item.dart';
import 'package:template/api/index.dart';
import 'package:template/routers/application.dart';

class HomeMorePage extends StatefulWidget {
  final int cat;
  const HomeMorePage({Key key, this.cat}) : super(key: key);
  @override
  _HomeMorePageState createState() => _HomeMorePageState();
}

class _HomeMorePageState extends State<HomeMorePage> {
  // 排序字段：sort默认sort
  String sortBy = 'sort';
  // 排序方式：ASC,DESC ，默认ASC
  String sortMethod = 'ASC';
  int page = 1;
  // 类型：1=首页推荐，2=highPassRate，3=hot，4=newProduct，5=非会员推荐，6=非会员VIP专区，7=会员Game Zone

  List diversionList = [
    // {
    // "product_id": 1,
    // "product_type": 1,
    // "product_name": "Long Term Loan",
    // "product_image": "1",
    // "product_desc": "Long Term Loan",
    // "amount": "3000~7000",
    // "term": "10 days",
    // "interest": "3%",
    // "link": "http://www.baidu.com",
    // "link_type": 1, //1=APP内跳转，2=打开浏览器跳转
    // }
  ];

  _fetchGameListData() async {
    var raw = await httpUtil.get('/products', {
      'sortBy': sortBy,
      'sortMethod': sortMethod,
      'page': page,
      'cat': widget.cat,
    });

    if (raw['status'] == 200) {
      setState(() {
        diversionList = raw['data'];
      });
    } else {
      showToast(raw['message']);
    }
  }

  _onTap(id, link, linkType) async {
    print(11111);
    print(id);
    print(link);
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
  void initState() {
    _fetchGameListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'More',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          children: diversionList.map((item) {
            return DiveriosnListItem(
              type: 1,
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
      ),
    );
  }
}
