import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/format.dart';
import 'package:template/components/button.dart';

class WithdrawPage extends StatefulWidget {
  final int balance;
  const WithdrawPage({Key key, this.balance}) : super(key: key);
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _btnActive = false;

  _submit() async {
    if (_mobileController.text == '' ||
        _nameController.text == '' ||
        _ifscCodeController.text == '' ||
        _bankController.text == '' ||
        _amountController.text == '') {
      showToast('Please fill in the complete information');
      return;
    }
    var raw = await httpUtil.post('/balance/withdraw', {
      'mobile': _mobileController.text,
      'full_name': _nameController.text,
      'ifsc': _ifscCodeController.text,
      'account_number': _bankController.text,
      'amount': (num.parse(_amountController.text) * 100).toInt(),
    });

    if (raw['status'] == 200) {
      showToast('Submit Success');
    } else {
      showToast(raw['message']);
    }
  }

  void _textFieldChanged(String str) {
    print('--------------');
    if (_mobileController.text.length > 0 &&
        _nameController.text.length > 0 &&
        _ifscCodeController.text.length > 0 &&
        _bankController.text.length > 0 &&
        _amountController.text.length > 0) {
      _btnActive = true;
    } else {
      _btnActive = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Balance Withdraw',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
        ),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // labelText: 'Mobile Number:',
                        hintText: 'Please enter the mobile number',
                        hintStyle: TextStyle(color: Color(0xffB1B2BA)),
                      ),
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(16),
                      ),
                      onChanged: _textFieldChanged,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // labelText: 'Full Name:',
                        hintText: 'Please enter the full name of the payee',
                        hintStyle: TextStyle(color: Color(0xffB1B2BA)),
                        // contentPadding: EdgeInsets.only(top: 15),
                      ),
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(16),
                      ),
                      onChanged: _textFieldChanged,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: TextField(
                      controller: _bankController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // labelText: 'Bank Account Number:',
                        hintText:
                            'Please enter the receiving bank account number',
                        hintStyle: TextStyle(color: Color(0xffB1B2BA)),
                        // contentPadding: EdgeInsets.only(top: 15),
                      ),
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(16),
                      ),
                      onChanged: _textFieldChanged,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: TextField(
                      controller: _ifscCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        // labelText: 'IFSC Code:',
                        hintText: 'Please enter the IFSC code',
                        hintStyle: TextStyle(color: Color(0xffB1B2BA)),
                        // contentPadding: EdgeInsets.only(top: 15),
                      ),
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(16),
                      ),
                      onChanged: _textFieldChanged,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText:
                            'The bank charges a service fee of Rs 9.5 per withdrawal',
                        hintText: 'Please enter the amount of withdrawal',
                        labelStyle: TextStyle(color: Color(0xffB1B2BA)),
                        hintStyle: TextStyle(color: Color(0xffB1B2BA)),
                        // contentPadding: EdgeInsets.only(top: 15),
                      ),
                      style: TextStyle(
                        fontSize: ScreenUtil().setWidth(16),
                      ),
                      onChanged: _textFieldChanged,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Color(0xffd8d8d8)),
                      ),
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StyleText(
                            text: 'Withdrawal Balance',
                            size: 15,
                            color: Color(0xffB1B2BA),
                          ),
                          StyleText(
                            text: '₹${Format.formatMoney(widget.balance)}',
                            size: 15,
                            color: StyleColors.defaultColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 40),
              child: Button(
                text: 'Submit',
                active: _btnActive,
                onTap: _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
