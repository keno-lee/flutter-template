import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:oktoast/oktoast.dart';

import 'package:template/routers/routes.dart';
import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/components/button.dart';
import 'package:template/api/index.dart';
import 'package:template/utils/track.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fathernameController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _birth = ''; // 生日
  String _genderText = '';
  int _gender; // 性别
  String _maritalText = '';
  int _marital; // 婚姻状态
  bool _btnActive = false; // 是否激活按钮

  // 获取生日
  _getBirthDate() {
    showDatePicker(
      context: context,
      initialDate: new DateTime.now(), // 初始日期
      firstDate: new DateTime.now().subtract(
        new Duration(days: 36500),
      ), // 减 100年
      lastDate: new DateTime.now(), // 当天
    ).then((DateTime val) {
      print(val); // 2020-07-27 00:00:00.000
      setState(() {
        _birth = '${val.year}-${val.month}-${val.day}';
        _textFieldChanged('');
      });
    }).catchError((err) {
      print(err);
    });
  }

  _getGender() {
    customSelector(
      title: 'Select Gender',
      pickerData: ['Male', 'Female'],
      callback: (index, value) {
        print(index);
        print(value);
        setState(() {
          _genderText = value;
          _gender = index + 1;
          _textFieldChanged('');
        });
      },
    );
  }

  _getMarital() {
    customSelector(
      title: 'Select Marital Status',
      pickerData: ['UnMarried', 'Married'],
      callback: (index, value) {
        print(index);
        print(value);
        setState(() {
          _maritalText = value;
          _marital = index;
          _textFieldChanged('');
        });
      },
    );
  }

  void _submit() async {
    if (_nameController.text == '' ||
        _fathernameController.text == '' ||
        _birth == '' ||
        _gender == null ||
        _marital == null ||
        _panController.text == '' ||
        _aadharController.text == '' ||
        _emailController.text == '') {
      showToast('Please fill in the complete information');
      return;
    }

    var raw = await httpUtil.put('/v2/info', {
      'name': _nameController.text,
      'father_name': _fathernameController.text,
      'birth_date': _birth,
      'gender': _gender,
      'married_status': _marital,
      'pan_number': _panController.text,
      'aadhaar_number': _aadharController.text,
      'email': _emailController.text,
    });

    if (raw['status'] == 200) {
      track.personalInfoUpdate();

      Navigator.pushReplacementNamed(context, Routes.authentication);
    } else {
      showToast(raw['message']);
    }
  }

// name	是	string	姓名
// father_name	是	string
// birth_date	是	string	出生日期
// gender	是	int	性别 1=男，2=女
// married_status	是	int	婚姻状态：1=已婚，0=未婚
// pan_number	是	string
// aadhaar_number	是	string
// email	是	string	邮箱
  // 监听input文案变化
  void _textFieldChanged(String str) {
    print('--------------');
    if (_nameController.text.length > 0 &&
        _fathernameController.text.length > 0 &&
        _birth != '' &&
        _gender != null &&
        _marital != null &&
        _panController.text.length > 0 &&
        _aadharController.text.length > 0 &&
        _emailController.text.length > 0) {
      _btnActive = true;
    } else {
      _btnActive = false;
    }
    setState(() {});
  }

  // 自定义选择器
  void customSelector({List pickerData, String title, Function callback}) {
    new Picker(
      adapter: PickerDataAdapter<String>(pickerdata: pickerData),
      // hideHeader: true,
      // builderHeader: (context) => Stack(
      //   overflow: Overflow.visible,
      //   children: <Widget>[
      //     Container(
      //       height: 40,
      //       color: Colors.white,
      //       padding: EdgeInsets.only(
      //         left: 14,
      //         right: 14,
      //       ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           GestureDetector(
      //             child: Text(
      //               'Cancel',
      //               style: TextStyle(color: Color(0xff999999), fontSize: 18),
      //             ),
      //           ),
      //           GestureDetector(
      //             child: Text(
      //               'Determine',
      //               style: TextStyle(color: Color(0xff333333), fontSize: 18),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     Positioned(
      //       top: -20,
      //       left: 0,
      //       right: 0,
      //       child: Container(
      //         height: 20,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(20),
      //             topRight: Radius.circular(20),
      //           ),
      //         ),x
      //       ),
      //     ),
      //   ],
      // ),
      cancelText: 'Cancel',
      cancelTextStyle: TextStyle(color: Color(0xff999999), fontSize: 18),
      confirmText: 'Determine',
      confirmTextStyle:
          TextStyle(color: StyleColors.defaultColor, fontSize: 18),
      textStyle: TextStyle(color: Color(0xff333333), fontSize: 20),
      height: ScreenUtil().setWidth(200),
      itemExtent: ScreenUtil().setWidth(45),
      onConfirm: (Picker picker, List value) {
        callback(value[0], picker.getSelectedValues()[0]);
      },
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
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
          bottom: ScreenUtil().setWidth(20),
        ),
        child: Column(
          children: <Widget>[
            InformationInputCell(
              title: 'Name',
              value: '222',
              controller: _nameController,
              onChanged: _textFieldChanged,
            ),
            InformationInputCell(
              title: 'Father Name',
              value: '222',
              controller: _fathernameController,
              onChanged: _textFieldChanged,
            ),
            InformationSelectCell(
              title: 'Date of Birth',
              value: _birth,
              onTap: _getBirthDate,
            ),
            InformationSelectCell(
              title: 'Gender',
              value: _genderText,
              onTap: _getGender,
            ),
            InformationSelectCell(
              title: 'Marital Status',
              value: _maritalText,
              onTap: _getMarital,
            ),
            InformationInputCell(
              title: 'PAN No',
              value: '222',
              controller: _panController,
              type: TextInputType.number,
              onChanged: _textFieldChanged,
            ),
            InformationInputCell(
              title: 'Aadhar No',
              value: '222',
              controller: _aadharController,
              type: TextInputType.number,
              onChanged: _textFieldChanged,
            ),
            InformationInputCell(
              title: 'Email',
              value: '222',
              controller: _emailController,
              type: TextInputType.emailAddress,
              onChanged: _textFieldChanged,
            ),
            Container(height: ScreenUtil().setWidth(25)),
            Button(
              text: 'Submit',
              onTap: _submit,
              active: _btnActive,
            )
          ],
        ),
      ),
    );
  }
}

class InformationInputCell extends StatelessWidget {
  final TextInputType type;
  final String title;
  final String value;
  final Function onChanged;
  final TextEditingController controller;

  const InformationInputCell({
    Key key,
    this.title,
    this.value,
    this.type: TextInputType.text,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      height: ScreenUtil().setWidth(50),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            fontSize: 14,
          ),
          // helperText: 'helperText',
          // hintText: 'enter $title',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: StyleColors.pirmaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: StyleColors.tertiaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class InformationSelectCell extends StatelessWidget {
  final String title;
  final String value;
  final Function onTap;

  const InformationSelectCell({
    Key key,
    this.title,
    this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.only(left: 12, right: 12),
        height: ScreenUtil().setWidth(50),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: StyleColors.tertiaryColor,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            value == ''
                ? StyleText(
                    text: '$title',
                    color: Color(0xff777777),
                    size: 14,
                  )
                : StyleText(
                    text: value,
                    color: StyleColors.defaultColor,
                    size: ScreenUtil().setWidth(16),
                  ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xff9A9A9A),
            ),
          ],
        ),
      ),
    );
  }
}
