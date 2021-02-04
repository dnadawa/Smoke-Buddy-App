import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/notification-model.dart';
import 'package:smoke_buddy/screens/forums/comments.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../constants.dart';
import 'custom-text.dart';

class PostWidget extends StatefulWidget {

  final String name;
  final String date;
  final String description;
  final String proPic;
  final String image;
  final String uid;
  final String authorId;
  final List likes;
  final List following;
  final String postId;

  const PostWidget({Key key, this.name, this.date, this.proPic, this.image, this.description, this.uid, this.authorId, this.likes, this.following, this.postId}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  bool liked = false;
  bool followed = false;
  List<DocumentSnapshot> comments;
  StreamSubscription<QuerySnapshot> subscription;
  getComments(String postID)async{
    subscription = FirebaseFirestore.instance.collection('posts').doc(postID).collection('comments').orderBy('time',descending: true).snapshots().listen((datasnapshot){
      setState(() {
        comments = datasnapshot.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///for likes
    if(widget.likes.contains(widget.uid)){
      setState(() {
        liked = true;
      });
    }
    else{
      setState(() {
        liked = false;
      });
    }


    ///for follows
    if(widget.following.contains(widget.uid)){
      setState(() {
        followed = true;
      });
    }
    else{
      setState(() {
        followed = false;
      });
    }

    getComments(widget.postId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: Constants.kFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3,color: Constants.kFillOutlineColor)
      ),
      child: Column(
        children: [

          ///propic and name
          ListTile(
            leading: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Profile(uid: widget.authorId,)),
                );
              },
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.proPic),
              ),
            ),
            title: CustomText(text: widget.uid==widget.authorId?'Me':widget.name,align: TextAlign.start,),
            subtitle: CustomText(text: widget.date,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
          ),

          ///text
          if(widget.description!='')
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: CustomText(
              text: widget.description,
              align: TextAlign.start,
              isBold: false,
              size: ScreenUtil().setSp(35),
            ),
          ),

          ///image
          Visibility(
            visible: widget.image!='',
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: CachedNetworkImage(
                imageUrl: widget.image,
                fit: BoxFit.fill,
                placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
              ),
            ),
          ),

          ///button bar
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ///likes
                GestureDetector(
                  onTap: () async {
                    List likes = widget.likes;

                    if(!likes.contains(widget.uid)){
                      ToastBar(text: 'Please wait',color: Colors.orange).show();
                      likes.add(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'likes': likes
                      });

                      ///send notifications
                      NotificationModel.sendLikeNotification(postID: widget.postId,receiverID: widget.authorId,following: widget.following);

                      setState(() {
                        liked=true;
                      });
                    }
                    else{
                      likes.remove(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'likes': likes
                      });
                      setState(() {
                        liked=false;
                      });
                    }
                    },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(liked?Icons.favorite:Icons.favorite_border,color: liked?Colors.red:Colors.black,),
                        SizedBox(width: ScreenUtil().setWidth(10),),
                        CustomText(text: '${widget.likes.length} Likes',)
                      ],
                    ),
                  ),
                ),

                ///comments
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Comments(postID: widget.postId,authorID: widget.authorId,following: widget.following,)),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: ScreenUtil().setWidth(10),),
                        CustomText(text: '${comments!=null?comments.length:0} Comments',)
                      ],
                    ),
                  ),
                ),

                ///follow
                if(widget.authorId!=widget.uid)
                GestureDetector(
                  onTap: () async {
                    ToastBar(text: 'Please wait',color: Colors.orange).show();
                    List following = widget.following;

                    if(!widget.following.contains(widget.uid)){
                      following.add(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'following': following
                      });

                      ///send notification
                      await NotificationModel.sendFollowNotification(receiverID: widget.authorId,postID: widget.postId);

                      setState(() {
                        followed=true;
                      });
                    }
                    else{
                      following.remove(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'following': following
                      });
                      setState(() {
                        followed=false;
                      });
                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(followed?Icons.notifications_active:Icons.notifications_none, color: followed?Colors.blue:Colors.black,),
                        SizedBox(width: ScreenUtil().setWidth(10),),
                        CustomText(text: followed?'Following':'Follow',)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          ///single comment
          if(comments!=null&&comments.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(comments[0]['authorImage']),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
              dense: true,
              title: CustomText(text: comments[0]['authorID']==widget.uid?'Me':comments[0]['authorName'],align: TextAlign.start,),
              subtitle: CustomText(text: comments[0]['comment'],align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
            ),
          )

        ],
      ),
    );
  }
}
