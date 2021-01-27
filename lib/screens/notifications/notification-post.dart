import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

import '../../constants.dart';

class NotificationPost extends StatefulWidget {
  final String postID;

  const NotificationPost({Key key, this.postID}) : super(key: key);

  @override
  _NotificationPostState createState() => _NotificationPostState();
}

class _NotificationPostState extends State<NotificationPost> {

  String image,authorName,authorImage, authorID ,post, date, uid;
  List likes,following;

  getPost() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    uid = preferences.get('uid');


    await FirebaseFirestore.instance.collection('posts').doc(widget.postID).get().then((value){
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'POST',color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: authorImage!=null?PostWidget(
                image: image,
                name: authorName,
                date: date,
                proPic: authorImage,
                description: post,
                authorId: authorID,
                uid: uid,
                following: following,
                likes: likes,
                postId: widget.postID,
              ):Center(child: CircularProgressIndicator(),),
            ),
          ),
        ),
      ),
    );
  }
}
