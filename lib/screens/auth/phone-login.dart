import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/constants.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
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
              padding: const EdgeInsets.all(20),
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
                      initialSelection: 'Denmark',
                      textStyle: TextStyle(
                          fontFamily: 'Antonio',
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(35)
                      ),
                      onChanged: (code)=>print(code),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(30),),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: Constants.kLoginTextStyle,
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
                onPressed: (){},
              ),
            ),
            Spacer(flex: 4),

            ///login with email
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
              child: CustomText(
                text: 'Login with e-mail, click here!',
                isBold: false,
              ),
            ),


            ///register with email
            Padding(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
              child: CustomText(
                text: 'Register by e-mail, click here!',
                isBold: false,
              ),
            )



          ],
        ),
      ),
    );
  }
}
