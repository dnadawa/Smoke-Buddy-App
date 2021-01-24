import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/screens/auth/email-login.dart';
import 'package:smoke_buddy/screens/forums/posts.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';
import '../home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Stack(
          children: [
            ///backdrop
            Column(
              children: [
                ///status bar
                Container(
                  height: ScreenUtil().statusBarHeight,
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                ),

                ///dark green container
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  color: Theme.of(context).primaryColor,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Row(
                        children: [
                          ///backbutton
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Constants.kYellow,
                              ),
                              onPressed: () => Navigator.pop(context)),

                          ///logo
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => Home()),
                                );
                              },
                              child: SizedBox(
                                  height: ScreenUtil().setHeight(100),
                                  child: Image.asset('assets/images/appbar.png')))
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: ScreenUtil().setHeight(110),),


                    ///2nd container
                    Container(
                      height: ScreenUtil().screenHeight / 4 - ScreenUtil().setHeight(125),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ///follow button
                          SizedBox(
                            width: ScreenUtil().setWidth(400),
                            height: ScreenUtil().setHeight(100),
                            child: Button(
                              text: 'FOLLOW',
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20),),

                          ///tabbar
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Constants.kMainTextColor,
                            tabs: [
                              Tab(
                                child: Column(
                                  children: [
                                    CustomText(text: 'POSTS'),
                                    CustomText(text: '5',),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Column(
                                  children: [
                                    CustomText(text: 'FOLLOWERS'),
                                    CustomText(text: '512',),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Column(
                                  children: [
                                    CustomText(text: 'FOLLOWING'),
                                    CustomText(text: '524',),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///tabview

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Posts(),
                          Posts(),
                          Posts(),
                        ],
                      ),
                    )




              ],
            ),


            ///profile name
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
                child: Container(
                  width: ScreenUtil().setWidth(600),
                  height: ScreenUtil().setWidth(250),
                  decoration: BoxDecoration(
                    color: Color(0xffa5ce31),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xff3c4a22),width: 2)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: ScreenUtil().setHeight(60),),
                        CustomText(text: 'Sanjula Hasaranga',size: ScreenUtil().setSp(50),),
                        CustomText(text: 'puka kamu',isBold: false,),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            ///profile propic
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(220)),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: ScreenUtil().setHeight(80),
                  ),
                )
            ),
          ],
        ),
      ),
      bottomSheet: AppBottomSheet(),
    );
  }
}
