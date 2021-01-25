import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smoke_buddy/screens/auth/register.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';
import '../home.dart';

class EmailOTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              ///logo
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              CustomText(
                text: 'Email Verification',
                isBold: false,
                size: ScreenUtil().setSp(40),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              CustomText(
                text: 'Enter the code sent to dulajnadawa@gmail.com',
                isBold: false,
                size: ScreenUtil().setSp(30),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),


              ///text field
              Padding(
                padding:  EdgeInsets.all(ScreenUtil().setHeight(40)),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onChanged: (code){},
                  backgroundColor: Colors.transparent,
                  enablePinAutofill: false,
                  textStyle: Constants.kLoginTextStyle,
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  pastedTextStyle: Constants.kLoginTextStyle,
                  pinTheme: PinTheme(
                    activeColor: Constants.kFillOutlineColor,
                    inactiveColor: Constants.kMainTextColor,
                    selectedColor: Constants.kFillColor
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(35),
              ),

              ///resend
              CustomText(
                text: "Didn't receive the code? RESEND",
                isBold: false,
                size: ScreenUtil().setSp(35),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(150),
              ),

              ///button
              SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(100),
                child: Button(
                  text: 'VERIFY',
                  onPressed: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Register()),
                    );
                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(180),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
