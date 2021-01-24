import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/constants.dart';
import 'package:smoke_buddy/screens/forums/create-post.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

import 'comments.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
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
                  backgroundImage: NetworkImage(
                      'https://hgtvhome.sndimg.com/content/dam/images/hgtv/fullset/2015/11/10/0/CI_Costa-Farms-Ballad-aster.jpg.rend.hgtvcom.966.644.suffix/1447169929799.jpeg'),
                ),
                SizedBox(width: ScreenUtil().setWidth(20),),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePost()),
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
