import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom-text.dart';


class ToastBar{

  final String text;
  final Color color;

  ToastBar({this.text, this.color});

  FToast fToast = FToast();
  //
  // show(){
  //   Fluttertoast.showToast(
  //     msg: text,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     backgroundColor: color,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );
  // }

  show(BuildContext context) {
    fToast.init(context);

    Widget toast = Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Color(0xff3b4a22),width: 2),
          color: color==Colors.green?Color(0xff84a93f):color,
        ),
        child: CustomText(text: text.toUpperCase(),),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

  }

}