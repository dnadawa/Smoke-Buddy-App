import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smoke_buddy/screens/auth/phone-create-password.dart';
import 'package:smoke_buddy/screens/auth/phone-enter-password.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

class PhoneOTP extends StatefulWidget {

  final String phone;

  const PhoneOTP({Key key, this.phone}) : super(key: key);

  @override
  _PhoneOTPState createState() => _PhoneOTPState();
}

class _PhoneOTPState extends State<PhoneOTP> {

  String gVerificationId;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showResend = false;
  TextEditingController code = TextEditingController();

  sendOtp() async {
    print(widget.phone);
    await auth.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('verification failed'+e.toString());
        ToastBar(text: 'Too many Requests! Please Try Again Later!',color: Colors.red).show(context);
      },
      codeSent: (String verificationId, int resendToken) async {
        print('code sent');
        gVerificationId = verificationId;
        ToastBar(text: 'Code Sent!',color: Colors.orange).show(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          showResend = true;
        });
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                text: 'Phone Number Verification',
                isBold: false,
                size: ScreenUtil().setSp(40),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              CustomText(
                text: 'Enter the code sent to ${widget.phone}',
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
                    sendOtp();
                    setState(() {
                      showResend = false;
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
                  onPressed: () async {

                    try{
                      ToastBar(text: 'Please wait...',color: Colors.orangeAccent).show(context);
                      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: gVerificationId, smsCode: code.text);
                      await auth.signInWithCredential(phoneAuthCredential);


                      ///check user exists
                      var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: auth.currentUser.uid).get();
                      var users = sub.docs;

                      ToastBar(text: 'Phone Verified!',color: Colors.green).show(context);

                      if(users.isEmpty){
                        //navigate to create password page
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     CupertinoPageRoute(builder: (context) =>
                        //         Register(uid: auth.currentUser.uid,phone: widget.phone,email: '',password: '',)), (Route<dynamic> route) => false);

                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) =>
                                PhoneCreatePassword(uid: auth.currentUser.uid,phone: widget.phone,)), (Route<dynamic> route) => false);
                      }
                      else{

                        //navigate  to enter password page

                        // Navigator.of(context).pushAndRemoveUntil(
                        //     CupertinoPageRoute(builder: (context) =>
                        //        Home()), (Route<dynamic> route) => false);

                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) =>
                                PhoneEnterPassword(password: users[0]['password'], uid: users[0]['id'],)), (Route<dynamic> route) => false);
                      }




                    }
                    on FirebaseAuthException catch(e){
                      if(e.code == 'session-expired'){
                        ToastBar(text: 'Code is expired!',color: Colors.red).show(context);
                      }
                      else if(e.code == 'invalid-verification-code'){
                        ToastBar(text: 'Code is invalid!',color: Colors.red).show(context);
                      }
                    }
                    catch(e){
                      ToastBar(text: 'Something went wrong!',color: Colors.red).show(context);
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
