import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:template/style/text.dart';
import 'package:template/style/colors.dart';
import 'package:template/components/button.dart';
import 'package:template/api/index.dart';
import 'package:template/components/dialog.dart';

class UploadPage extends StatefulWidget {
  final int id;
  final int proofCount;
  const UploadPage({Key key, this.id, this.proofCount}) : super(key: key);
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // File _image;
  // final picker = ImagePicker();
  bool _btnActive = false;

  List<File> imageList = [];
  List<String> imageUploadList = [];

  Future _upload(index) async {
    print(index);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                _takePhoto(index);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Select from photo gallery'),
              onTap: () {
                _openGallery(index);
                Navigator.pop(context);
              },
            ),
            Container(height: 10, color: StyleColors.separateColor),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _takePhoto(index) async {
    PickedFile pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 30);

    _postImageUpload(index, pickedFile);

    imageList[index] = File(pickedFile.path);
    setState(() {});
  }

  _openGallery(index) async {
    PickedFile pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 30);
    // print(pickedFile);
    File file = File(pickedFile.path);
    _postImageUpload(index, file);

    imageList[index] = File(pickedFile.path);
    setState(() {});
  }

  // 上传图片接口
  void _postImageUpload(index, file) async {
    FormData postData =
        FormData.fromMap({"file": await MultipartFile.fromFile(file.path)});
    print(postData);

    var raw = await httpUtil.post('/image/upload', postData);

    if (raw['status'] == 200) {
      imageUploadList[index] = raw['data']['image_url'];
      _btnActiveCheck();
      setState(() {});
    } else {
      showToast(raw['message']);
    }
  }

  // 提交图片列表
  void _postImageSubmit() async {
    if (!_btnActive) return;
    var options = new Options(contentType: 'application/json');
    var raw = await httpUtil.post(
      '/tasks/submit/${widget.id}',
      {'proof': imageUploadList},
      options,
    );

    if (raw['status'] == 200) {
      CustomDialog.show(
        context,
        content:
            'Your task has been submitted for review and the review results will be available within 3 working days',
        hasClose: false,
        onTap: () {
          // 退回到任务中心
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } else {
      showToast(raw['message']);
    }
  }

  Future image2Base64(File file) async {
    // File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    // print(base64Encode(imageBytes));
    return base64Encode(imageBytes);
  }

  // 检查接口
  void _btnActiveCheck() {
    if (imageUploadList.contains(null)) {
      _btnActive = false;
    } else {
      _btnActive = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    print(widget.id);
    print(widget.proofCount);
    for (var i = 0; i < widget.proofCount; i++) {
      imageList.add(null);
      imageUploadList.add(null);
    }
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Task Screenshot',
          style: TextStyle(color: Color(0xff333333)),
        ),
        iconTheme: IconThemeData(color: Color(0xff333333)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(16),
                bottom: ScreenUtil().setWidth(16),
              ),
              child: Wrap(
                runSpacing: ScreenUtil().setWidth(10),
                spacing: ScreenUtil().setWidth(10),
                children: imageList.asMap().keys.map((index) {
                  return UploadItem(
                    upload: _upload,
                    image: imageList[index],
                    index: index,
                  );
                }).toList(),
                //  <Widget>[
                //   UploadItem(upload: _upload, image: imageList[0], index: 0),
                //   UploadItem(upload: _upload, image: imageList[1], index: 1),
                //   UploadItem(upload: _upload, image: imageList[2], index: 2),
                // ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(16),
              right: ScreenUtil().setWidth(16),
              top: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setWidth(40),
            ),
            child: Column(
              children: <Widget>[
                Button(
                  text: 'OK',
                  onTap: _postImageSubmit,
                  active: _btnActive,
                ),
                Container(
                  width: ScreenUtil().setWidth(240),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(18)),
                  child: StyleText(
                    text:
                        'Funds will be credited within three working days after submission and approval',
                    size: ScreenUtil().setWidth(11),
                    color: StyleColors.tertiaryColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UploadItem extends StatelessWidget {
  final Function upload;
  final File image;
  final int index;
  const UploadItem({
    Key key,
    this.upload,
    this.image,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        upload(index);
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(108),
        height: ScreenUtil().setWidth(108),
        padding: EdgeInsets.only(
            // top: ScreenUtil().setWidth(34),
            // bottom: ScreenUtil().setWidth(28),
            ),
        decoration: BoxDecoration(
          color: Color(0xffF9F9F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 1,
            color: Color(0xffE7E7E7),
          ),
        ),
        child: image == null
            ? Center(
                child: Icon(Icons.add, size: 40),
              )
            : Image.file(
                image,
                width: ScreenUtil().setWidth(108),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
