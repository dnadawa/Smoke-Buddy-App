import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/constants.dart';
import 'package:smoke_buddy/screens/forums/create-post.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

import 'comments.dart';

class Posts extends StatefulWidget {

  final String category;

  const Posts({Key key, this.category}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String proPic='https://i.pinimg.com/originals/90/80/60/9080607321ab98fa3e70dd24b2513a20.gif';
  String uid;
  String name;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var users = sub.docs;
    if(users.isNotEmpty){
      print(users[0]['name']);
      setState(() {
        proPic = users[0]['proPic'];
        name = users[0]['name'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Column(
          children: [


            ///create post
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Constants.kFillColor,
                  radius: 25,
                  backgroundImage: NetworkImage(proPic),
                ),
                SizedBox(width: ScreenUtil().setWidth(20),),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePost(uid: uid,category: widget.category,proPic: proPic,name: name,)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Constants.kFillColor,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(width: 3,color: Constants.kFillOutlineColor)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                        child: CustomText(text: "What's on your mind...",size: ScreenUtil().setSp(25),align: TextAlign.start,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),

            ///feed
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                 PostWidget(
                   image: 'https://d3hnfqimznafg0.cloudfront.net/images/news/ImageForNews_26919_15786618897301054.png',
                   name: 'Dulaj Nadawa',
                   date: '2020.12.12',
                   proPic: 'https://d3hnfqimznafg0.cloudfront.net/images/news/ImageForNews_26919_15786618897301054.png',
                   description: 'I can extract them Nikolina, But the problem is if we get the images from the PDF they will not be in high quality. So, if you/your previous developer can provide',
                 ),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
