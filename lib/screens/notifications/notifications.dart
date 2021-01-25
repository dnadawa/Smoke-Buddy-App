import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/drawer.dart';
import 'package:smoke_buddy/screens/forums/posts.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/screens/profile/post.dart';
import 'package:smoke_buddy/screens/wallpapers/wallpaper-feed.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';
import 'package:smoke_buddy/widgets/tab-button.dart';

import '../../constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>  with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
          child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Home()),
                );
              },
              child: Image.asset('assets/images/appbar.png')),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity,ScreenUtil().setHeight(100)),
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: CustomText(text: 'NOTIFICATIONS',color: Theme.of(context).accentColor,size: ScreenUtil().setSp(50),),
          ),
        ),
      ),
      drawer: Drawer(
        child: MenuDrawer(screen: 'notifications',),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Constants.kYellow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 3,color: Constants.kMainTextColor)
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                  child: Column(
                    children: [

                      ///notification
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                        child: Row(
                          children: [
                            Icon(Icons.favorite_outlined,color: Constants.kMainTextColor,),
                            SizedBox(width: ScreenUtil().setHeight(10),),
                            CustomText(text: 'Dulaj Nadawa liked your post',size: ScreenUtil().setSp(35),),
                          ],
                        ),
                      ),


                      ///post
                      PostWidget(
                        image: '',
                        description: 'Hello there is is just a ui',
                        proPic: '',
                        date: '2021/12/12',
                        name: 'Sanjula',
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: AppBottomSheet(),
    );
  }
}
