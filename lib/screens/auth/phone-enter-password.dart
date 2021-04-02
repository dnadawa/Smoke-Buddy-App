import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';


import '../../constants.dart';
import '../home.dart';


// ignore: must_be_immutable
class PhoneEnterPassword extends StatelessWidget {
  final String password;
  final String uid;
  TextEditingController enteredPassword = TextEditingController();

  PhoneEnterPassword({Key key, this.password, this.uid}) : super(key: key);

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
                text: 'ENTER PASSWORD',
                size: ScreenUtil().setSp(55),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              ///password
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'ENTER PASSWORD',controller: enteredPassword,isPassword: true,),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),

              ///Button
              SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(100),
                child: Button(
                  text: 'NEXT',
                  onPressed: () async {
                    if(password==md5.convert(utf8.encode(enteredPassword.text)).toString()){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('uid', uid);

                      Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) =>
                              Home()), (Route<dynamic> route) => false);
                    }
                    else{
                      ToastBar(text: 'Password is incorrect',color: Colors.red).show(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
