import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/moderator/admin-forums.dart';
import 'package:smoke_buddy/screens/settings/about.dart';

import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';
import '../home.dart';

// ignore: must_be_immutable
class EmailLogin extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
                text: 'LOG IN',
                size: ScreenUtil().setSp(55),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(25),
              ),

              ///email
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'EMAIL',type: TextInputType.emailAddress,controller: email,),
              ),
              ///password
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'PASSWORD',isPassword: true,controller: password,),
              ),

              ///forget password
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
                child: GestureDetector(
                  onTap: () async {
                    try{
                      if(email.text.isNotEmpty) {
                        ToastBar(text: 'Please wait',color: Colors.orange).show(context);
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.sendPasswordResetEmail(email: email.text);
                        ToastBar(text: 'Password reset link sent to your email!',color: Colors.green).show(context);
                      }
                      else{
                        ToastBar(text: 'Please fill the email',color: Colors.red).show(context);
                      }
                    }
                    on FirebaseAuthException catch(e){
                      if (e.code == 'user-not-found') {
                        ToastBar(text: 'No user found for that email',color: Colors.red).show(context);
                      }
                      else{
                        ToastBar(text: 'Something went wrong!',color: Colors.red).show(context);
                      }
                    }
                  },
                  child: CustomText(
                    text: 'RESET PASSWORD',
                    isBold: false,
                  ),
                ),
              ),

              ///loginButton
              SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(100),
                child: Button(
                  text: 'SAVE',
                  onPressed: () async {

                    ToastBar(text: 'Please wait',color: Colors.orange).show(context);

                    try {

                      var sub = await FirebaseFirestore.instance.collection('admin').where('email', isEqualTo: email.text).where('password', isEqualTo: md5.convert(utf8.encode(password.text)).toString()).get();
                      var admin = sub.docs;

                      if(admin.isNotEmpty){
                        //go to admin home
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) =>
                                AdminForums(index: 0,)), (Route<dynamic> route) => false);
                      }
                      else{
                        //do others
                        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text
                        );

                        ToastBar(text: 'Logged in!',color: Colors.green).show(context);

                        String uid = userCredential.user.uid;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('uid', uid);

                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) =>
                                Home()), (Route<dynamic> route) => false);
                      }


                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ToastBar(text: 'No user found for that email',color: Colors.red).show(context);
                      } else if (e.code == 'wrong-password') {
                        ToastBar(text: 'Password incorrect',color: Colors.red).show(context);
                      }
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
