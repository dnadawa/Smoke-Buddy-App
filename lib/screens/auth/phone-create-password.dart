import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/auth/phone-login.dart';
import 'package:smoke_buddy/screens/auth/register.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';


// ignore: must_be_immutable
class PhoneCreatePassword extends StatelessWidget {
  final String uid;
  final String phone;
  final String type;

  TextEditingController confirmPassword = TextEditingController();
  TextEditingController password = TextEditingController();

  PhoneCreatePassword({Key key, this.uid, this.phone, this.type='normal'}) : super(key: key);
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
                text: 'CREATE PASSWORD',
                size: ScreenUtil().setSp(55),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              ///create password
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'CREATE PASSWORD',controller: password,isPassword: true,),
              ),
              ///confirm password
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'CONFIRM PASSWORD',isPassword: true,controller: confirmPassword,),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),

              ///Button
              SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(100),
                child: Button(
                  text: 'SAVE',
                  onPressed: () async {
                    if(password.text==confirmPassword.text){
                      if(type=='normal'){
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => Register(uid: uid,phone: phone,email: '',password: md5.convert(utf8.encode(password.text)).toString(),)),
                        );
                      }
                      else{
                          await FirebaseFirestore.instance.collection('users').doc(uid).update({
                            'password': md5.convert(utf8.encode(password.text)).toString()
                          });
                          ToastBar(text: 'Password changed successfully!',color: Colors.green).show(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) =>
                                  Home()), (Route<dynamic> route) => false);
                      }
                    }
                    else{
                      ToastBar(text: 'Password does not match!',color: Colors.red).show(context);
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
