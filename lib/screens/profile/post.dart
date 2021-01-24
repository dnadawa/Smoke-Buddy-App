import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
            child: PostWidget(
              image: 'https://d3hnfqimznafg0.cloudfront.net/images/news/ImageForNews_26919_15786618897301054.png',
              name: 'Dulaj Nadawa',
              date: '2020.12.12',
              proPic: 'https://d3hnfqimznafg0.cloudfront.net/images/news/ImageForNews_26919_15786618897301054.png',
              description: 'I can extract them Nikolina, But the problem is if we get the images from the PDF they will not be in high quality. So, if you/your previous developer can provide',
            ),
          ),
        ],
      ),
    );
  }
}
