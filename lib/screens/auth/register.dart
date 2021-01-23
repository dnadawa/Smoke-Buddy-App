import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

enum Gender { male, female, other }

class _RegisterState extends State<Register> {
  Gender _gender = Gender.male;
  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'REGISTER',
          color: Theme.of(context).accentColor,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///upload photo
              Center(
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(60)),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Constants.kFillColor,
                    child: Icon(
                      Icons.camera_alt,
                      color: Constants.kMainTextColor,
                      size: 35,
                    ),
                  ),
                ),
              ),

              ///form
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Username',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Status',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Email',
                  type: TextInputType.emailAddress,
                ),
              ),

              ///radios
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: CustomText(
                    text: 'Please select your gender',
                    size: ScreenUtil().setSp(35)),
              ),

              ///male
              RadioListTile(
                value: Gender.male,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Male',
                  align: TextAlign.start,
                ),
              ),
              ///female
              RadioListTile(
                value: Gender.female,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Female',
                  align: TextAlign.start,
                ),
              ),
              ///other
              RadioListTile(
                value: Gender.other,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Other',
                  align: TextAlign.start,
                ),
              ),


              ///terms and conditions
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              CheckboxListTile(
                  value: accept,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Constants.kMainTextColor,
                  onChanged: (val){
                    setState(() {
                      accept = val;
                    });
                  },
                  title: GestureDetector(
                    onTap: () async =>await launch('https://www.smokebuddy.eu/pages/privacy-policy'),
                    child: CustomText(text: 'I accept all terms and conditions',align: TextAlign.start,),
                  ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),


              ///button
              Center(
                child: SizedBox(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(100),
                  child: Button(
                    text: 'SAVE',
                    onPressed: (){},
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
