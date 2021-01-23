import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom-text.dart';

class AppBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async =>await launch('https://www.smokebuddy.eu/supportus'),
      child: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: ScreenUtil().setHeight(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: 'SUPPORT',size: ScreenUtil().setSp(40),color: Theme.of(context).accentColor,),
            SizedBox(width: ScreenUtil().setWidth(20),),
            SizedBox(
                height: ScreenUtil().setHeight(65),
                child: Image.asset('assets/images/heart.png')),
            SizedBox(width: ScreenUtil().setWidth(20),),
            CustomText(text: 'SMOKEBUDDY',size: ScreenUtil().setSp(40),color: Theme.of(context).accentColor,),
          ],
        ),
      ),
    );
  }
}
