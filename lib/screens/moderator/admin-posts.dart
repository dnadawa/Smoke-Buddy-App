import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/widgets/admin-post-widget.dart';


class AdminPosts extends StatefulWidget {

  final String category;

  const AdminPosts({Key key, this.category}) : super(key: key);

  @override
  _AdminPostsState createState() => _AdminPostsState();
}

class _AdminPostsState extends State<AdminPosts> {
  String proPic='https://media2.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif';
  String uid;
  String name;
  List<DocumentSnapshot> posts;
  StreamSubscription<QuerySnapshot> subscription;

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

  getPosts(){
    subscription = FirebaseFirestore.instance.collection('posts').where('category',isEqualTo: widget.category).where('report', isEqualTo: 'pending').orderBy('publishedDate', descending: true).snapshots().listen((datasnapshot){
      setState(() {
        posts = datasnapshot.docs;
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
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
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        child: Column(
          children: [

            ///feed
            Expanded(
              child: posts!=null?ListView.builder(
                itemCount: posts.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context,i){

                  String image = posts[i]['image'];
                  String video = posts[i]['video'];
                  String authorName = posts[i]['authorName'];
                  String authorImage = posts[i]['authorImage'];
                  String authorID = posts[i]['authorID'];
                  String post = posts[i]['post'];
                  String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(posts[i]['publishedDate']));
                  List likes = posts[i]['likes'];
                  List following = posts[i]['following'];

                  print(post);
                  return Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                    child: AdminPostWidget(
                      image: image,
                      name: authorName,
                      video: video,
                      date: date,
                      proPic: authorImage,
                      description: post,
                      authorId: authorID,
                      uid: uid,
                      following: following,
                      likes: likes,
                      postId: posts[i].id,
                    ),
                  );
                },
              ):Center(child: CircularProgressIndicator(),),
            )
          ],
        ),
      ),
    );
  }
}
