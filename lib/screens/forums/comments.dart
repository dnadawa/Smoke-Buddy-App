import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/notification-model.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

class Comments extends StatefulWidget {

  final String postID;
  final List following;
  final List likes;
  final String authorID;

  const Comments({Key key, this.postID, this.following, this.authorID, this.likes}) : super(key: key);


  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  TextEditingController comment = TextEditingController();
  String uid;
  String proPic='https://media2.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif';
  String userName;
  List<DocumentSnapshot> comments;
  StreamSubscription<QuerySnapshot> subscription;
  List commentersIDs = [];

  getPosts(){
    subscription = FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('comments').orderBy('time',descending: true).snapshots().listen((datasnapshot){
      setState(() {
        comments = datasnapshot.docs;
        comments.forEach((element) {
          commentersIDs.add(element['authorID']);
        });
      });
    });
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var users = sub.docs;
    if(users.isNotEmpty){
      print(users[0]['name']);
      setState(() {
        proPic = users[0]['proPic'];
        userName = users[0]['name'];
      });
    }
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
      appBar: AppBar(
        title: CustomText(
          text: 'COMMENTS',
          color: Theme.of(context).accentColor,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            children: [

              Expanded(
                child: comments!=null?ListView.builder(
                  itemCount: comments.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context,i){

                    String proPic = comments[i]['authorImage'];
                    String name = comments[i]['authorName'];
                    String comment = comments[i]['comment'];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(proPic),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                      title: CustomText(text: name==userName?'Me':name,align: TextAlign.start,),
                      subtitle: CustomText(text: comment,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
                    );
                  },
                ):Center(child: CircularProgressIndicator(),),
              ),



              ///comment box
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(proPic),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10),),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Antonio',
                      ),
                      controller: comment,
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration(
                        hintText: 'Type a comment...',
                        hintStyle: TextStyle(
                          fontFamily: 'Antonio',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send,color: Constants.kMainTextColor,),
                          onPressed: () async {
                            ToastBar(text: 'Commenting...',color: Colors.orange).show();
                            await FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('comments').add({
                              'time': DateTime.now().toString(),
                              'comment': comment.text,
                              'authorName': userName,
                              'authorImage': proPic,
                              'authorID': uid,
                            });

                            ///sendNotification
                            NotificationModel.sendCommentNotification(postID: widget.postID,receiverID: widget.authorID,following: widget.following, likes: widget.likes, comments: commentersIDs);

                            ToastBar(text: 'Comment added!',color: Colors.green).show();
                            comment.clear();
                          },
                        ),
                        filled: true,
                        fillColor: Constants.kFillColor,
                        contentPadding: EdgeInsets.all(ScreenUtil().setWidth(35)),
                        enabledBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Constants.kFillOutlineColor, width: 2),
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Constants.kFillOutlineColor, width: 2),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
