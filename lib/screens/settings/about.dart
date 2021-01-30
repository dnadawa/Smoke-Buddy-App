import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/settings/policies.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

// ignore: must_be_immutable
class About extends StatelessWidget {



  Widget popUp = Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    child: Container(
      height: 400,
      decoration: BoxDecoration(
          gradient: Constants.appGradient,
          border: Border.all(color: Constants.kFillOutlineColor,width: 3),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset("assets/images/logo.png", height: 100),
          ],
        ),
      ),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(text: 'ABOUT',color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///logo
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                  child: Image.asset('assets/images/logo.png'),
                ),


                ///about app
                ListTile(
                  title: CustomText(text: 'About App',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context){
                        return popUp;
                      }
                    );
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),


                ///rate us
                ListTile(
                  title: CustomText(text: 'Rate Us',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()async=>launch('https://play.google.com/store/apps/details?id=com.digiwrecks.smokebuddy'),
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),

                ///community rules
                ListTile(
                  title: CustomText(text: 'SmokeBuddy Community Rules',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Policies(title: 'COMMUNITY RULES',)),
                    );
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),

                ///agreement
                ListTile(
                  title: CustomText(text: 'End User License Agreement',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => Policies(title: 'END USER LICENSE AGREEMENT',)),
                    );
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),

                ///privacy policy
                ListTile(
                  title: CustomText(text: 'Privacy Policy',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: ()async=>launch('https://www.smokebuddy.eu/pages/privacy-policy'),
                ),
                SizedBox(height: ScreenUtil().setHeight(20),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
