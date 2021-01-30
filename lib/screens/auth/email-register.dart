import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/auth/email-otp.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class EmailRegister extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

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


              ///email
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40),ScreenUtil().setWidth(40),ScreenUtil().setWidth(40),0),
                child: InputField(hint: 'EMAIL',type: TextInputType.emailAddress,controller: email,),
              ),
              ///password
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                child: InputField(hint: 'CREATE PASSWORD',isPassword: true,controller: password,),
              ),
              ///confirm password
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40),0,ScreenUtil().setWidth(40),ScreenUtil().setWidth(40)),
                child: InputField(hint: 'CONFIRM PASSWORD',isPassword: true,controller: confirmPassword,),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),

              ///button
              SizedBox(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setHeight(100),
                child: Button(
                  text: 'NEXT',
                  onPressed: (){

                    if(password.text==confirmPassword.text){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => EmailOTP(email: email.text,password: password.text,)),
                      );
                    }
                    else{
                      ToastBar(text: 'Password does not match!',color: Colors.red).show();
                    }




                  },
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(180),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: CustomText(
                    text: 'Register by phone, click here!',
                    isBold: false,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
