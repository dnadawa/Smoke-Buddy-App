import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/constants.dart';
import 'package:smoke_buddy/screens/auth/email-register.dart';
import 'package:smoke_buddy/screens/auth/phone-otp.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'email-login.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {

  TextEditingController phone = TextEditingController();
  String countryCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(100)),
            ///logo
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
              child: Image.asset('assets/images/logo.png'),
            ),
            Spacer(flex: 1),

            ///loginForm
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black,width: 2)
                      )
                    ),
                    child: CountryCodePicker(
                      showDropDownButton: false,
                      showFlagDialog: true,
                      showFlag: false,
                      showFlagMain: true,
                      dialogBackgroundColor: Constants.kYellow,
                      dialogTextStyle: TextStyle(
                        fontFamily: 'Antonio'
                      ),
                      initialSelection: 'Danmark',
                      textStyle: TextStyle(
                          fontFamily: 'Antonio',
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(35)
                      ),
                      onChanged: (code){
                        countryCode=code.toString();
                        print(countryCode);
                      },
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(30),),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: Constants.kLoginTextStyle,
                      controller: phone,
                      decoration: InputDecoration(
                        hintText: 'PHONE NUMBER',
                        hintStyle: Constants.kLoginTextStyle,
                        contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2)
                        ),
                        focusColor: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Spacer(flex: 2),

            ///loginButton
            SizedBox(
              width: ScreenUtil().setWidth(400),
              height: ScreenUtil().setHeight(100),
              child: Button(
                text: 'NEXT',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => PhoneOTP(phone: countryCode+phone.text,)),
                  );
                },
              ),
            ),
            Spacer(flex: 4),

            ///login with email
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => EmailLogin()),
                  );
                },
                child: CustomText(
                  text: 'Login with e-mail, click here!',
                  isBold: false,
                ),
              ),
            ),


            ///register with email
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => EmailRegister()),
                  );
                },
                child: CustomText(
                  text: 'Register by e-mail, click here!',
                  isBold: false,
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
