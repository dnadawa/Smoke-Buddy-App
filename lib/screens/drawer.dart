import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/forums/forums.dart';
import 'package:smoke_buddy/screens/notifications/notification-post.dart';
import 'package:smoke_buddy/screens/notifications/notifications.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/screens/settings/settings.dart' as settings;
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
  List<DocumentSnapshot> notifications;
  StreamSubscription<QuerySnapshot> subscription;

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

  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    subscription = FirebaseFirestore.instance.collection('notifications').where('uid', arrayContains: uid).orderBy('time', descending: true).snapshots().listen((datasnapshot){
      setState(() {
        notifications = datasnapshot.docs;
      });
    });
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
      getNotifications();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: Constants.appGradient,
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
                            Color(0xff84a94f),
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
                              getNotifications();
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



                          ///blog
                          DrawerSideButton(
                            name: 'BLOG',
                            image: 'blog.png',
                            onTap: ()async=>await launch('https://www.smokebuddy.eu/blogs'),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),


                          Expanded(
                            child: Container(),
                          ),


                          ///profile
                          DrawerSideButton(
                            name: 'PROFILE',
                            image: 'profile.png',
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String uid = prefs.getString('uid');

                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Profile(uid: uid,)),
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
                                CupertinoPageRoute(builder: (context) => settings.Settings()),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///title
                          Center(child: CustomText(text: 'FORUMS',size: ScreenUtil().setSp(50),)),
                          SizedBox(height: ScreenUtil().setHeight(40),),

                          ///buttons column
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                            child: Column(
                              children: [
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

                        ],
                      ),
                    ),

                    ///WALLPAPERS OPTIONS
                    if(wallpaperActive)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///title
                            Center(child: CustomText(text: 'WALLPAPERS',size: ScreenUtil().setSp(50),)),
                            SizedBox(height: ScreenUtil().setHeight(40),),


                            ///buttons
                            Padding(
                              padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                              child: Column(
                                children: [
                                  ///artists
                                  SizedBox(
                                    width: ScreenUtil().setWidth(360),
                                    child: Button(
                                      text: 'ARTISTS',
                                      // fontSize: ScreenUtil().setSp(60),
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
                                    width: ScreenUtil().setWidth(360),
                                    child: Button(
                                      text: 'CHRISTIANIA',
                                      // fontSize: ScreenUtil().setSp(60),
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
                                    width: ScreenUtil().setWidth(360),
                                    child: Button(
                                      text: 'SMOKEBUDDY',
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

                    ///NOTIFICATIONS
                    if(notificationActive)
                      Expanded(
                        child: Column(
                          children: [
                            ///title
                            CustomText(text: 'NOTIFICATIONS',size: ScreenUtil().setSp(50),),
                            SizedBox(height: ScreenUtil().setHeight(40),),

                            ///notification
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                                child: notifications!=null?ListView.builder(
                                  itemCount: notifications.length,
                                  itemBuilder: (context,i){

                                    String notification = notifications[i]['notification'];
                                    String postID;
                                    String type = notifications[i]['type'];
                                    if(type!='profileFollow'){
                                      postID = notifications[i]['postID'];
                                    }


                                    return Padding(
                                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
                                      child: GestureDetector(
                                        onTap: (){
                                          if(type!='profileFollow') {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      NotificationPost(
                                                        postID: postID,)),
                                            );
                                          }
                                          else{
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(builder: (context) => Profile(uid: notifications[i]['followerID'],)),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Constants.kFillColor,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                    type=='postLike'?Icons.favorite:
                                                    type=='postComment'?Icons.comment:
                                                    type=='postFollow'?Icons.addchart:
                                                    type=='profileFollow'?Icons.person_add:
                                                    Icons.create),
                                                SizedBox(width: ScreenUtil().setWidth(10),),
                                                SizedBox(
                                                    width: ScreenUtil().setWidth(270),
                                                    child: CustomText(text: notification,align: TextAlign.start,)
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ):Center(child: CircularProgressIndicator(),),
                              ),
                            ),


                            ///see all
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Notifications()),
                                );
                              },
                              child: CustomText(text: 'SEE ALL',size: ScreenUtil().setSp(40),),
                            )

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
