import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smoke_buddy/screens/auth/register.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';
import '../home.dart';

class EmailOTP extends StatefulWidget {
  final String email;
  final String password;

  const EmailOTP({Key key, this.email, this.password}) : super(key: key);

  @override
  _EmailOTPState createState() => _EmailOTPState();
}

class _EmailOTPState extends State<EmailOTP> {

  bool showResend = false;
  int randomCode;
  TextEditingController code = TextEditingController();

  startTimer(){
    Timer(Duration(seconds: 20),(){
      setState(() {
        showResend = true;
      });
    });
  }

  sendOtp() async {
    String username = 'smokebuddy8@gmail.com';
    String password = 'Smokebuddy@123';

    int min = 100000;
    int max = 999999;
    var rnd = Random();
    randomCode = min + rnd.nextInt(max - min);

    final smtpServer = gmail(username, password);
    // Create our message.
    final message = Message()
      ..from = Address(username, 'Smoke Buddy')
      ..recipients.add(widget.email)
      ..subject = 'OTP Code'
      ..text = 'Your OTP Code for email verification is '+randomCode.toString();

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      ToastBar(text: 'OTP send to your email!',color: Colors.green).show();
    } on MailerException catch (e) {
      print('Message not sent.');
      ToastBar(text: 'Error sending email!',color: Colors.red).show();
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    sendOtp();
  }

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
                text: 'Enter the code sent to ${widget.email}',
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
                  controller: code,
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
              Visibility(
                visible: showResend,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showResend = false;
                      startTimer();
                      sendOtp();
                    });
                  },
                  child: CustomText(
                    text: "Didn't receive the code? RESEND",
                    isBold: false,
                    size: ScreenUtil().setSp(35),
                  ),
                ),
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
                    print(randomCode);
                    print(code.text);
                    if(code.text==randomCode.toString()){
                      ToastBar(text: 'Email Verified',color: Colors.green).show();
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => Register(phone: '',uid: '',password: widget.password,email: widget.email,)),
                      );
                    }
                    else{
                      ToastBar(text: 'OTP is incorrect!',color: Colors.red).show();
                    }
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
