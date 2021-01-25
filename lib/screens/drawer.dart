import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/screens/forums/forums.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/screens/settings/settings.dart';
import 'package:smoke_buddy/screens/wallpapers/wallpapers.dart';
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

  String currentScreen;

  ///side menu
  bool forumActive = true;
  bool notificationActive = false;
  bool wallpaperActive = false;

  ///status
  bool op1Active = true;
  bool op2Active = false;
  bool op3Active = false;
  bool op4Active = false;


  ///wallpapers
  bool artistsActive = true;
  bool christianiaActive = false;
  bool smokeBuddyActive = false;

  getForumsSelected(){
    if(widget.controller.index==0){
      op1Active = true;
      op2Active = false;
      op3Active = false;
      op4Active = false;
    }
    else if(widget.controller.index==1){
      op1Active = false;
      op2Active = true;
      op3Active = false;
      op4Active = false;
    }
    else if(widget.controller.index==2){
      op1Active = false;
      op2Active = false;
      op3Active = true;
      op4Active = false;
    }
    else{
      op1Active = false;
      op2Active = false;
      op3Active = false;
      op4Active = true;
    }
  }

  getWallpapersSelected(){
    if(widget.controller.index==0){
      artistsActive = true;
      christianiaActive = false;
      smokeBuddyActive = false;
    }
    else if(widget.controller.index==1){
      artistsActive = false;
      christianiaActive = true;
      smokeBuddyActive = false;
    }
    else if(widget.controller.index==2){
      artistsActive = false;
      christianiaActive = false;
      smokeBuddyActive = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = widget.screen;
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
      getWallpapersSelected();
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


                    ///FORUMS OPTIONS
                    if(forumActive)
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
                              onPressed: () async {
                                setState(() {
                                  op1Active = true;
                                  op2Active = false;
                                  op3Active = false;
                                  op4Active = false;
                                });
                                if(currentScreen!='forums'){
                                  currentScreen='forums';
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Forums(index: 0,)),
                                  );
                                }
                                Forums.tabController.animateTo(0);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'status.png',
                              color: Colors.transparent,
                              isBorder: op1Active,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///gallery
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'GALLERY',
                              onPressed: () async {
                                setState(() {
                                  op1Active = false;
                                  op2Active = true;
                                  op3Active = false;
                                  op4Active = false;
                                });
                                if(currentScreen!='forums'){
                                  currentScreen='forums';
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Forums(index: 1,)),
                                  );
                                }
                                Forums.tabController.animateTo(1);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'gallery.png',
                              color: Colors.transparent,
                              isBorder: op2Active,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///grow
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'GROW',
                              onPressed: () async {
                                setState(() {
                                  op1Active = false;
                                  op2Active = false;
                                  op3Active = true;
                                  op4Active = false;
                                });
                                if(currentScreen!='forums'){
                                  currentScreen='forums';
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Forums(index: 2,)),
                                  );
                                }
                                Forums.tabController.animateTo(2);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'grow.png',
                              color: Colors.transparent,
                              isBorder: op3Active,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10),),

                          ///cooking
                          SizedBox(
                            width: ScreenUtil().setWidth(290),
                            child: Button(
                              text: 'COOKING',
                              onPressed: () async {
                                setState(() {
                                  op1Active = false;
                                  op2Active = false;
                                  op3Active = false;
                                  op4Active = true;
                                });
                                if(currentScreen!='forums'){
                                  currentScreen='forums';
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Forums(index: 3,)),
                                  );
                                }
                                Forums.tabController.animateTo(3);
                                Navigator.pop(context);
                              },
                              leadingImage: true,
                              image: 'cooking.png',
                              color: Colors.transparent,
                              isBorder: op4Active,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///WALLPAPERS OPTIONS
                    if(wallpaperActive)
                      Expanded(
                        child: Column(
                          children: [
                            ///title
                            CustomText(text: 'WALLPAPERS',size: ScreenUtil().setSp(50),),
                            SizedBox(height: ScreenUtil().setHeight(40),),

                            ///artists
                            SizedBox(
                              width: ScreenUtil().setWidth(320),
                              child: Button(
                                text: 'ARTISTS',
                                onPressed: () async {
                                  setState(() {
                                    artistsActive = true;
                                    christianiaActive = false;
                                    smokeBuddyActive = false;
                                  });

                                  if(currentScreen!='wallpapers'){
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Wallpapers(index: 0,)),
                                    );
                                    currentScreen='wallpapers';
                                  }
                                  Wallpapers.tabController.animateTo(0);
                                  Navigator.pop(context);
                                },
                                leadingImage: true,
                                image: 'artists.png',
                                color: Colors.transparent,
                                isBorder: artistsActive,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10),),

                            ///christiania
                            SizedBox(
                              width: ScreenUtil().setWidth(320),
                              child: Button(
                                text: 'CHRISTIANIA',
                                fontSize: ScreenUtil().setSp(60),
                                onPressed: () async {
                                  setState(() {
                                    artistsActive = false;
                                    christianiaActive = true;
                                    smokeBuddyActive = false;
                                  });
                                  if(currentScreen!='wallpapers'){
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Wallpapers(index: 1,)),
                                    );
                                    currentScreen='wallpapers';
                                  }
                                  Wallpapers.tabController.animateTo(1);
                                  Navigator.pop(context);
                                },
                                leadingImage: true,
                                image: 'christiania.png',
                                color: Colors.transparent,
                                isBorder: christianiaActive,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10),),

                            ///smokebuddy
                            SizedBox(
                              width: ScreenUtil().setWidth(320),
                              child: Button(
                                text: 'SMOKEBUDDY',
                                fontSize: ScreenUtil().setSp(55),
                                onPressed: () async {
                                  setState(() {
                                    artistsActive = false;
                                    christianiaActive = false;
                                    smokeBuddyActive = true;
                                  });
                                  if(currentScreen!='wallpapers'){
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Wallpapers(index: 2,)),
                                    );
                                    currentScreen='wallpapers';
                                  }
                                  Wallpapers.tabController.animateTo(2);
                                  Navigator.pop(context);
                                },
                                leadingImage: true,
                                image: 'smokebuddy.png',
                                color: Colors.transparent,
                                isBorder: smokeBuddyActive,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(10),),

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
