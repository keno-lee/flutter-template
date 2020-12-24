import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

class Layer {
  static dynamic ctx;

  static toast(msg) {
    // Fluttertoast.toast(
    //   msg: msg,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.CENTER,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Color.fromARGB(180, 0, 0, 0),
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    showToast(msg);
  }
}
