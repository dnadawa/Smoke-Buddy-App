import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/profile/followers.dart';
import 'package:smoke_buddy/screens/profile/post.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/marquee.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';
import '../../notification-model.dart';
import '../home.dart';

class Profile extends StatefulWidget {

  final String uid;
  static int postCount = 0;
  const Profile({Key key, this.uid}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String proPic = 'https://media2.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif';
  String name='n/a';
  String status='n/a';
  String loggedUid;
  List profileFollowing;
  List myFollowing;
  List profileFollowers;
  List myFollowers;
  bool hide = true;
  ScrollController _scrollController = ScrollController();
  ScrollController _nextController = ScrollController();

  getProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedUid = prefs.getString('uid');
    var sub2 = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: loggedUid).get();
    var myacc = sub2.docs;
    if(myacc.isNotEmpty){
      myFollowing = myacc[0]['following'];
      myFollowers = myacc[0]['followers'];
    }


    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: widget.uid).get();
    var users = sub.docs;
    if(users.isNotEmpty){
      setState(() {
        proPic = users[0]['proPic'];
        name = users[0]['name'];
        status = users[0]['status'];
        profileFollowing = users[0]['following'];
        profileFollowers = users[0]['followers'];
        hide = users[0]['hide'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(() {
      print(_scrollController.offset);
    });

    _nextController.addListener(() {
      print(_scrollController.offset);
      if(_nextController.offset>0&&_scrollController.offset==0){
        _scrollController.animateTo(157, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      }
      else if(_nextController.offset==0&&_scrollController.offset>=1){
        _scrollController.animateTo(0, duration: Duration(milliseconds: 100), curve: Curves.easeIn);
      }
    });

    getProfileData();
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
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
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

                SizedBox(height: ScreenUtil().setHeight(80),),


                    Expanded(
                      child: NestedScrollView(
                        physics: ScrollPhysics(),
                        controller: _scrollController,
                        headerSliverBuilder: (context,value){
                          return [
                            SliverAppBar(
                            title: widget.uid!=loggedUid&&myFollowing!=null&&profileFollowers!=null?SizedBox(
                              width: ScreenUtil().setWidth(400),
                              height: ScreenUtil().setHeight(100),
                              child: Button(
                                text: profileFollowers.contains(loggedUid)?'UNFOLLOW':'FOLLOW',
                                onPressed: () async {
                                  ToastBar(text: 'Please wait...',color: Colors.orange).show();

                                  ///add him to my following list
                                  if(myFollowing.contains(widget.uid)){
                                    myFollowing.remove(widget.uid);
                                  }
                                  else{
                                    myFollowing.add(widget.uid);
                                  }
                                  await FirebaseFirestore.instance.collection('users').doc(loggedUid).update({
                                    'following': myFollowing
                                  });


                                  ///add me to his followers lis
                                  if(profileFollowers.contains(loggedUid)){
                                    profileFollowers.remove(loggedUid);
                                  }
                                  else{
                                    profileFollowers.add(loggedUid);

                                    ///send notification
                                    NotificationModel.sendProfileFollowNotification(receiverID: widget.uid);
                                  }
                                  await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                                    'followers': profileFollowers
                                  });

                                  getProfileData();
                                  ToastBar(text: 'Followed',color: Colors.green).show();
                                },
                              ),
                            ):Container(),
                            backgroundColor: Colors.transparent,
                            floating: false,
                            pinned: false,
                            snap: false,
                            expandedHeight: ScreenUtil().setHeight(230),
                            automaticallyImplyLeading: false,
                            bottom: !hide||(widget.uid==loggedUid)?TabBar(
                              controller: _tabController,
                              indicatorColor: Constants.kMainTextColor,
                              tabs: [
                                Tab(
                                  child: Column(
                                    children: [
                                      CustomText(text: 'POSTS'),
                                      CustomText(text: Profile.postCount.toString(),),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Column(
                                    children: [
                                      CustomText(text: 'FOLLOWERS'),
                                      CustomText(text: profileFollowers!=null?profileFollowers.length.toString():'0',),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Column(
                                    children: [
                                      CustomText(text: 'FOLLOWING'),
                                      CustomText(text: profileFollowing!=null?profileFollowing.length.toString():'0',),
                                    ],
                                  ),
                                ),
                              ],
                            ):PreferredSize(child: SizedBox.shrink(),preferredSize: Size(0,0),),
                          )];
                        },
                        body: !hide||(widget.uid==loggedUid)?TabBarView(
                          controller: _tabController,
                          children: [
                            Posts(id: widget.uid,loggedID: loggedUid,scrollController: _nextController,),
                            Followers(followers: profileFollowers,scrollController: _nextController,),
                            Followers(followers: profileFollowing,scrollController: _nextController,), //this because same ui, don't need separate following and followers, only data change
                          ],
                        ):Center(child: CustomText(text: 'This profile is private',size: ScreenUtil().setSp(35),),),
                        // child: Column(
                        //   children: [
                        //     ///2nd container
                        //     Container(
                        //       height: ScreenUtil().screenHeight / 4 - ScreenUtil().setHeight(125),
                        //       width: double.infinity,
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           ///follow button
                        //           if(widget.uid!=loggedUid)
                        //             myFollowing!=null&&profileFollowers!=null?
                        //             SizedBox(
                        //               width: ScreenUtil().setWidth(400),
                        //               height: ScreenUtil().setHeight(100),
                        //               child: Button(
                        //                 text: profileFollowers.contains(loggedUid)?'UNFOLLOW':'FOLLOW',
                        //                 onPressed: () async {
                        //                   ToastBar(text: 'Please wait...',color: Colors.orange).show();
                        //
                        //                   ///add him to my following list
                        //                   if(myFollowing.contains(widget.uid)){
                        //                     myFollowing.remove(widget.uid);
                        //                   }
                        //                   else{
                        //                     myFollowing.add(widget.uid);
                        //                   }
                        //                   await FirebaseFirestore.instance.collection('users').doc(loggedUid).update({
                        //                     'following': myFollowing
                        //                   });
                        //
                        //
                        //                   ///add me to his followers lis
                        //                   if(profileFollowers.contains(loggedUid)){
                        //                     profileFollowers.remove(loggedUid);
                        //                   }
                        //                   else{
                        //                     profileFollowers.add(loggedUid);
                        //
                        //                     ///send notification
                        //                     NotificationModel.sendProfileFollowNotification(receiverID: widget.uid);
                        //                   }
                        //                   await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                        //                     'followers': profileFollowers
                        //                   });
                        //
                        //                   getProfileData();
                        //                   ToastBar(text: 'Followed',color: Colors.green).show();
                        //                 },
                        //               ),
                        //             ):Center(child: CircularProgressIndicator(),),
                        //           SizedBox(height: ScreenUtil().setHeight(20),),
                        //
                        //           ///tabbar
                        //           if(!hide||(widget.uid==loggedUid))
                        //             TabBar(
                        //               controller: _tabController,
                        //               indicatorColor: Constants.kMainTextColor,
                        //               tabs: [
                        //                 Tab(
                        //                   child: Column(
                        //                     children: [
                        //                       CustomText(text: 'POSTS'),
                        //                       CustomText(text: Profile.postCount.toString(),),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 Tab(
                        //                   child: Column(
                        //                     children: [
                        //                       CustomText(text: 'FOLLOWERS'),
                        //                       CustomText(text: profileFollowers!=null?profileFollowers.length.toString():'0',),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 Tab(
                        //                   child: Column(
                        //                     children: [
                        //                       CustomText(text: 'FOLLOWING'),
                        //                       CustomText(text: profileFollowing!=null?profileFollowing.length.toString():'0',),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //         ],
                              ),
                    ),
                        //
                        //     ///tabview
                        //     if(!hide||(widget.uid==loggedUid))
                        //       // Container(
                        //       //     child: Posts(id: widget.uid,loggedID: loggedUid,)),
                        //
                        //
                        //
                        //     if(!(!hide||(widget.uid==loggedUid)))
                        //       Center(
                        //         child: CustomText(text: 'This profile is private',size: ScreenUtil().setSp(35),),
                        //       )
                        //   ],
                        // ),
                      // ),
                    // ),





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
                        CustomText(text: name,size: ScreenUtil().setSp(50),),
                        MarqueeWidget(child: CustomText(text: status,isBold: false,)),
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
                    backgroundImage: CachedNetworkImageProvider(proPic),
                    radius: ScreenUtil().setHeight(80),
                  ),
                )
            ),
          ],
        ),
      ),
      // bottomSheet: AppBottomSheet(),
    );
  }
}
