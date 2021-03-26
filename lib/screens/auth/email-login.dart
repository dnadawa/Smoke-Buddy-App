import 'package:firebase_auth/firebase_auth.dart';
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
                    if(email.text.isNotEmpty) {
                      ToastBar(text: 'Please wait',color: Colors.orange).show();
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.sendPasswordResetEmail(email: email.text);
                      ToastBar(text: 'Password reset link sent to your email!',color: Colors.green).show();
                    }
                    else{
                      ToastBar(text: 'Please fill the email',color: Colors.red).show();
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

                    ToastBar(text: 'Please wait',color: Colors.orange).show();

                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                      );

                    ToastBar(text: 'Logged in!',color: Colors.green).show();

                    String uid = userCredential.user.uid;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('uid', uid);

                      Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) =>
                              Home()), (Route<dynamic> route) => false);

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ToastBar(text: 'No user found for that email',color: Colors.red).show();
                      } else if (e.code == 'wrong-password') {
                        ToastBar(text: 'Password incorrect',color: Colors.red).show();
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
