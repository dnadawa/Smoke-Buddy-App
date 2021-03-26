import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/drawer.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/marquee.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

import '../../constants.dart';
import 'notification-post.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>{

  List<DocumentSnapshot> notifications;
  StreamSubscription<QuerySnapshot> subscription;
  String uid;

  getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.get('uid');
    subscription = FirebaseFirestore.instance.collection('notifications').where('uid', arrayContains: uid).orderBy('time', descending: true).snapshots().listen((datasnapshot){
      setState(() {
        notifications = datasnapshot.docs;
      });
    });
  }

  getPost(String postID) async {
    String image,authorName,authorImage, authorID ,post, date;
    List likes,following;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.get('uid');


    await FirebaseFirestore.instance.collection('posts').doc(postID).get().then((value){
      setState(() {
        image = value['image'];
        authorName = value['authorName'];
        authorImage = value['authorImage'];
        authorID = value['authorID'];
        post = value['post'];
        date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(value['publishedDate']));
        likes = value['likes'];
        following = value['following'];
      });
    });

    Map data = {
      'image': image,
      'authorName': authorName,
      'authorImage': authorImage,
      'authorID': authorID,
      'post': post,
      'publishedDate': date,
      'likes': likes,
      'following': following,
    };
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
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
      appBar: AppBar(
        title: SizedBox(
          width: ScreenUtil().setWidth(430),
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
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                child: Container(
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
                          child: GestureDetector(
                            onTap: (){
                              if(type=='profileFollow'){
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => Profile(uid: notifications[i]['followerID'],)),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Icon(type=='postLike'?Icons.favorite:
                                type=='postComment'?Icons.comment:
                                type=='postFollow'?Icons.addchart:
                                type=='profileFollow'?Icons.person_add:
                                Icons.create,color: Constants.kMainTextColor,),
                                SizedBox(width: ScreenUtil().setHeight(10),),
                                SizedBox(
                                    width: ScreenUtil().setWidth(550),
                                    child: MarqueeWidget(child: CustomText(text: notification,size: ScreenUtil().setSp(35),align: TextAlign.start,))),
                              ],
                            ),
                          ),
                        ),


                        ///post

                        type!='profileFollow'?
                        FutureBuilder(
                          future: getPost(postID),
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              String image = snapshot.data['image'];
                              String authorName = snapshot.data['authorName'];
                              String authorImage = snapshot.data['authorImage'];
                              String authorID = snapshot.data['authorID'];
                              String post = snapshot.data['post'];
                              String date =snapshot.data['publishedDate'];
                              List likes = snapshot.data['likes'];
                              List following = snapshot.data['following'];

                              return Padding(
                                padding:  EdgeInsets.all(ScreenUtil().setWidth(10)),
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
                                  },
                                  child: PostWidget(
                                    image: image,
                                    name: authorName,
                                    date: date,
                                    proPic: authorImage,
                                    description: post,
                                    authorId: authorID,
                                    uid: uid,
                                    following: following,
                                    likes: likes,
                                    postId: postID,
                                  ),
                                ),
                              );

                            }
                            else{
                              return Center(child: CircularProgressIndicator(),);
                            }

                          },
                        ):Container()

                      ],
                    ),
                  ),
                ),
              );
            },
          ):Center(child: CircularProgressIndicator(),),
        ),
      ),
      bottomNavigationBar: AppBottomSheet(),
    );
  }
}
