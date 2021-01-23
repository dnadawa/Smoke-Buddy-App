import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class Home extends StatelessWidget {
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


              ///forums
              Button(
                text: 'FORUMS',
                onPressed: (){},
                image: 'forums.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///notifications
              Button(
                text: 'NOTIFICATIONS',
                onPressed: (){},
                image: 'notifications.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///wallpapers
              Button(
                text: 'WALLPAPERS',
                onPressed: (){},
                image: 'wallpapers.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///shop
              Button(
                text: 'SHOP',
                onPressed: () async => await launch('https://www.smokebuddy.eu/'),
                image: 'shop.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///game
              Button(
                text: 'GAME',
                onPressed: () async => await launch('https://www.smokebuddy.eu/smokebuddy-world'),
                image: 'game.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


            ],
          ),
        ),
      ),
      
      bottomSheet: AppBottomSheet(),
    );
  }
}
