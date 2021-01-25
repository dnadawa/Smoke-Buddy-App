import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/screens/settings/settings.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/drawer-side-button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class MenuDrawer extends StatefulWidget {

  final TabController controller;
  final String screen;

  const MenuDrawer({Key key, this.controller, this.screen}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  ///side menu
  bool forumActive = true;
  bool notificationActive = false;
  bool wallpaperActive = false;

  ///status
  bool statusActive = true;
  bool galleryActive = false;
  bool growActive = false;
  bool cookingActive = false;

  getForumsSelected(){
    if(widget.controller.index==0){
      statusActive = true;
      galleryActive = false;
      growActive = false;
      cookingActive = false;
    }
    else if(widget.controller.index==1){
      statusActive = false;
      galleryActive = true;
      growActive = false;
      cookingActive = false;
    }
    else if(widget.controller.index==2){
      statusActive = false;
      galleryActive = false;
      growActive = true;
      cookingActive = false;
    }
    else{
      statusActive = false;
      galleryActive = false;
      growActive = false;
      cookingActive = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.screen=='forums'){
      forumActive = true;
      notificationActive = false;
      wallpaperActive = false;
      getForumsSelected();
    }
    else if(widget.screen =='notifications'){
      forumActive = false;
      notificationActive = true;
      wallpaperActive = false;
    }
    else{
      forumActive = false;
      notificationActive = false;
      wallpaperActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffbfc430),
                  Color(0xff78983d),
                ]
            )
        ),
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(130),
            ),
            Expanded(
              child: Container(
                 // color: Colors.blue,
                child: Row(
                  children: [
                    ///sidebar
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff557334),
                            Color(0xff84a93f),
                          ],
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: ScreenUtil().setHeight(20),),


                          ///forums
                          DrawerSideButton(
                            name: 'FORUMS',
                            image: 'forums.png',
                            activate: forumActive,
                            onTap: (){
                              setState(() {
                                forumActive = true;
                                notificationActive = false;
                                wallpaperActive = false;
                              });
                            },
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///notifications
                          DrawerSideButton(
                            name: 'NOTIFICATIONS',
                            image: 'notifications.png',
                            activate: notificationActive,
                            onTap: (){
                              setState(() {
                                forumActive = false;
                                notificationActive = true;
                                wallpaperActive = false;
                              });
                            },
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),


                          ///wallpapers
                          DrawerSideButton(
                            name: 'WALLPAPERS',
                            image: 'wallpapers.png',
                            activate: wallpaperActive,
                            onTap: (){
                              setState(() {
                                forumActive = false;
                                notificationActive = false;
                                wallpaperActive = true;
                              });
                            },
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),


                          ///shop
                          DrawerSideButton(
                            name: 'SHOP',
                            image: 'shop.png',
                            onTap: ()async=>await launch('https://www.smokebuddy.eu/'),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///game
                          DrawerSideButton(
                            name: 'GAME',
                            image: 'game.png',
                            onTap: ()async=>await launch('https://www.smokebuddy.eu/smokebuddy-world'),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),

                          Expanded(
                            child: Container(),
                          ),


                          ///profile
                          DrawerSideButton(
                            name: 'PROFILE',
                            image: 'profile.png',
                            onTap: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Profile()),
                              );
                            },
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///settings
                          DrawerSideButton(
                            name: 'SETTINGS',
                            image: 'settings.png',
                            onTap: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Settings()),
                              );
                            },
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          ///title
                          CustomText(text: 'FORUMS',size: ScreenUtil().setSp(50),),
                          SizedBox(height: ScreenUtil().setHeight(40),),

                          ///status
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'STATUS',
                              onPressed: (){
                                setState(() {
                                  statusActive = true;
                                  galleryActive = false;
                                  growActive = false;
                                  cookingActive = false;
                                });
                                widget.controller.animateTo(0);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'status.png',
                              color: Colors.transparent,
                              isBorder: statusActive,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///gallery
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'GALLERY',
                              onPressed: (){
                                setState(() {
                                  statusActive = false;
                                  galleryActive = true;
                                  growActive = false;
                                  cookingActive = false;
                                });
                                widget.controller.animateTo(1);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'gallery.png',
                              color: Colors.transparent,
                              isBorder: galleryActive,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///grow
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'GROW',
                              onPressed: (){
                                setState(() {
                                  statusActive = false;
                                  galleryActive = false;
                                  growActive = true;
                                  cookingActive = false;
                                });
                                widget.controller.animateTo(2);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'grow.png',
                              color: Colors.transparent,
                              isBorder: growActive,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///cooking
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'COOKING',
                              onPressed: (){
                                setState(() {
                                  statusActive = false;
                                  galleryActive = false;
                                  growActive = false;
                                  cookingActive = true;
                                });
                                widget.controller.animateTo(3);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'cooking.png',
                              color: Colors.transparent,
                              isBorder: cookingActive,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(70),
            ),
          ],
        ),
      ),
    );
  }
}
