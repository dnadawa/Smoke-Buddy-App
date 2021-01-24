import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/settings/about.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(text: 'SETTINGS',color: Theme.of(context).accentColor,),
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

                ///account
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                  child: CustomText(text: 'ACCOUNT',size: ScreenUtil().setSp(40),),
                ),

                ///edit profile
                ListTile(
                  title: CustomText(text: 'Edit Profile',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),

                ///hide profile
                ListTile(
                  title: CustomText(text: 'Hide Profile',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                      value: false,
                      onChanged: (val){},
                      activeColor: Constants.kSwitchActiveColor,
                      trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),


                ///log out
                ListTile(
                  title: CustomText(text: 'Log Out',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),


                ///notifications
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                  child: CustomText(text: 'NOTIFICATIONS',size: ScreenUtil().setSp(40),),
                ),

                ///own posts
                ListTile(
                  title: CustomText(text: 'Own Posts',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                    value: true,
                    onChanged: (val){},
                    activeColor: Constants.kSwitchActiveColor,
                    trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),


                ///own posts
                ListTile(
                  title: CustomText(text: 'Other Posts',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                    value: true,
                    onChanged: (val){},
                    activeColor: Constants.kSwitchActiveColor,
                    trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),

                ///about
                ListTile(
                  title: CustomText(text: 'About',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => About()),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
