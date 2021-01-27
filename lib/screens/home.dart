import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/forums/forums.dart';
import 'package:smoke_buddy/screens/wallpapers/wallpapers.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../notification-model.dart';
import 'notifications/notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationModel.setPlayerID();
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
              SizedBox(height: ScreenUtil().setHeight(140)),
              ///logo
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: ScreenUtil().setHeight(60)),

              ///forums
              Button(
                text: 'FORUMS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Forums(index: 0,)),
                  );
                },
                image: 'forums.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///notifications
              Button(
                text: 'NOTIFICATIONS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Notifications()),
                  );
                },
                image: 'notifications.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///wallpapers
              Button(
                text: 'WALLPAPERS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Wallpapers(index: 0,)),
                  );
                },
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
