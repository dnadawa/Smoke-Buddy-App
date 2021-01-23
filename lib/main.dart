import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/screens/auth/phone-login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(720, 1520),
      allowFontScaling: true,
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: Color(0xff557334),
            accentColor: Color(0xff82a73f)
          ),
        home: PhoneLogin(),
      ),
    );
  }
}

