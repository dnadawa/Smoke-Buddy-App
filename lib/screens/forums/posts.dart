import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/constants.dart';
import 'package:smoke_buddy/screens/forums/create-post.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/post-widget.dart';

class Posts extends StatefulWidget {

  final String category;

  const Posts({Key key, this.category}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String proPic='https://media2.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif';
  String uid;
  String name;
  List posts;
  List<DocumentSnapshot> users;
  StreamSubscription<QuerySnapshot> subscription;
  RefreshController _refreshController = RefreshController();

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    // var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    // var users = sub.docs;
    // if(users.isNotEmpty){
    //   print(users[0]['name']);
    //   setState(() {
    //     proPic = users[0]['proPic'];
    //     name = users[0]['name'];
    //   });
    // }
    subscription = FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).snapshots().listen((datasnapshot){
      setState(() {
        users = datasnapshot.docs;
        if(users!=null){
          proPic = users[0]['proPic'];
          name = users[0]['name'];
        }
      });
    });
  }

  getPosts() async {
    var sub = await FirebaseFirestore.instance.collection('posts').where('category',isEqualTo: widget.category).orderBy('publishedDate', descending: true).get();
    posts = sub.docs;
    _refreshController.refreshCompleted();
    setState(() {});
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

            ///create post
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Constants.kFillColor,
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(proPic),
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
                        child: CustomText(text: widget.category!='gallery'?"Create a post":"Upload media",size: ScreenUtil().setSp(25),align: TextAlign.start,),
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
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: getPosts,
                header: WaterDropMaterialHeader(
                  distance: 40,
                ),
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
                    String thumbnail = posts[i]['thumbnail'];
                    String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(posts[i]['publishedDate']));
                    List likes = posts[i]['likes'];
                    List following = posts[i]['following'];


                    return Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                      child: PostWidget(
                        image: image,
                        name: authorName,
                        video: video,
                        date: date,
                        proPic: authorImage,
                        description: post,
                        authorId: authorID,
                        thumbnail: thumbnail,
                        uid: uid,
                        following: following,
                        likes: likes,
                        postId: posts[i].id,
                      ),
                    );
                  },
                ):Center(child: CircularProgressIndicator(),),
              ),
              // child: posts!=null?ListView.builder(
              //   itemCount: posts.length,
              //   physics: BouncingScrollPhysics(),
              //   itemBuilder: (context,i){
              //
              //     String image = posts[i]['image'];
              //     String video = posts[i]['video'];
              //     String authorName = posts[i]['authorName'];
              //     String authorImage = posts[i]['authorImage'];
              //     String authorID = posts[i]['authorID'];
              //     String post = posts[i]['post'];
              //     String thumbnail = posts[i]['thumbnail'];
              //     String date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(posts[i]['publishedDate']));
              //     List likes = posts[i]['likes'];
              //     List following = posts[i]['following'];
              //
              //
              //     return Padding(
              //       padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              //       child: PostWidget(
              //         image: image,
              //         name: authorName,
              //         video: video,
              //         date: date,
              //         proPic: authorImage,
              //         description: post,
              //         authorId: authorID,
              //         thumbnail: thumbnail,
              //         uid: uid,
              //         following: following,
              //         likes: likes,
              //         postId: posts[i].id,
              //       ),
              //     );
              //   },
              // ):Center(child: CircularProgressIndicator(),),
            )
          ],
        ),
      ),
    );
  }
}
