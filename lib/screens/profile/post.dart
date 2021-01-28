import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

class Posts extends StatefulWidget {

  final String id;
  final String loggedID;
  final ScrollController scrollController;

  const Posts({Key key, this.id, this.loggedID, this.scrollController}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<DocumentSnapshot> posts;
  StreamSubscription<QuerySnapshot> subscription;

  getPosts(){
    subscription = FirebaseFirestore.instance.collection('posts').where('authorID', isEqualTo: widget.id).orderBy('publishedDate', descending: true).snapshots().listen((datasnapshot){
      setState(() {
        posts = datasnapshot.docs;
        Profile.postCount = posts.length;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
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
      backgroundColor: Colors.transparent,
      body: posts!=null?Padding(
        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
        child: ListView.builder(
          itemCount: posts.length,
          controller: widget.scrollController,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,i){

            String image = posts[i]['image'];
            String authorName = posts[i]['authorName'];
            String authorImage = posts[i]['authorImage'];
            String authorID = posts[i]['authorID'];
            String post = posts[i]['post'];
            String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(posts[i]['publishedDate']));
            List likes = posts[i]['likes'];
            List following = posts[i]['following'];

            return Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              child: PostWidget(
                image: image,
                name: authorName,
                date: date,
                proPic: authorImage,
                description: post,
                authorId: authorID,
                uid: widget.loggedID,
                following: following,
                likes: likes,
                postId: posts[i].id,
              ),
            );
          },
        ),
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
