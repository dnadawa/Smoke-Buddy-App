

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin Constants {

  ///gradient of scaffold background
  static const appGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff78983d),
        Color(0xffbfc430)
      ]
  );

  ///light green color
  static const kYellow = Color(0xffbfc430);
  ///main text color
  static const kMainTextColor = Color(0xff3c4a22);
  ///transparent fill
  static var kFillColor = Colors.white.withOpacity(0.35);
  ///transparent fill outline
  static var kFillOutlineColor = Color(0xff3c4a22).withOpacity(0.35);


  ///login pages text styles for input fields
  static var kLoginTextStyle = TextStyle(
      fontFamily: 'Antonio',
      letterSpacing: 0.6,
      fontWeight: FontWeight.bold,
      fontSize: ScreenUtil().setSp(35)
  );


}