import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';

class WithdrawReocrdDetailPage extends StatefulWidget {
  final int type;
  final int status;
  final String date;
  final String amount;
  final String balance;
  final String source;
  final String reason;
  final String serialNumber;
  const WithdrawReocrdDetailPage({
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
  _WithdrawReocrdDetailPageState createState() =>
      _WithdrawReocrdDetailPageState();
}

class _WithdrawReocrdDetailPageState extends State<WithdrawReocrdDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.type == 1 ? 'Make Money' : 'Withdraw',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(16),
          right: ScreenUtil().setWidth(16),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(80),
              child: Center(
                child: StyleText(
                  text: '${widget.type == 1 ? '+' : '-'} ₹${widget.amount}',
                  color:
                      widget.type == 1 ? Color(0xffFF3A3A) : Color(0xff333333),
                  size: ScreenUtil().setWidth(35),
                ),
              ),
            ),
            DetailItem(
              title: 'Types of',
              value: widget.type == 1 ? 'Make Money' : 'Withdraw',
            ),
            DetailItem(title: 'Time', value: widget.date),
            DetailItem(
              title: 'Source of funds',
              value: widget.source,
            ),
            DetailItem(
              title: 'T.number',
              value: widget.serialNumber,
            ),
            DetailItem(
              title: 'Account Balance',
              value: '₹ ${widget.balance}',
            ),
            DetailItem(
              title: 'Status',
              value: widget.status == 2
                  ? 'Failure'
                  : widget.status == 1
                      ? 'Success'
                      : 'Under Review',
            ),
            widget.reason != ''
                ? Container(
                    alignment: Alignment.center,
                    color: Color(0xffF4F4F4),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      right: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setWidth(8),
                      bottom: ScreenUtil().setWidth(8),
                    ),
                    child: StyleText(
                      text: 'Cause of failure : Imperfect personal information',
                      size: ScreenUtil().setWidth(13),
                      color: StyleColors.secondaryColor,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String title;
  final String value;
  const DetailItem({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(38),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StyleText(
            text: title,
            size: ScreenUtil().setWidth(15),
            color: StyleColors.tertiaryColor,
          ),
          StyleText(
            text: value,
            size: ScreenUtil().setWidth(15),
            color: StyleColors.defaultColor,
          ),
        ],
      ),
    );
  }
}
