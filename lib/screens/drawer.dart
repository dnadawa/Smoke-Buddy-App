import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/drawer-side-button.dart';

import '../constants.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
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
                            activate: true,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///notifications
                          DrawerSideButton(
                            name: 'NOTIFICATIONS',
                            image: 'notifications.png',
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),


                          ///wallpapers
                          DrawerSideButton(
                            name: 'WALLPAPERS',
                            image: 'wallpapers.png',
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),


                          ///shop
                          DrawerSideButton(
                            name: 'SHOP',
                            image: 'shop.png',),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///game
                          DrawerSideButton(
                            name: 'GAME',
                            image: 'game.png',
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),

                          Expanded(
                            child: Container(),
                          ),


                          ///profile
                          DrawerSideButton(
                            name: 'PROFILE',
                            image: 'profile.png',
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30),),



                          ///settings
                          DrawerSideButton(
                            name: 'SETTINGS',
                            image: 'settings.png',
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
