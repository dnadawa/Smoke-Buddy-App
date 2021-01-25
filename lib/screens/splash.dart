import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/auth/phone-login.dart';

import '../constants.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) =>
          PhoneLogin()), (Route<dynamic> route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/splash.png'),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(70)),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xff658918),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff013245)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
