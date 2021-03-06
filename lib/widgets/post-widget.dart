import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smoke_buddy/notification-model.dart';
import 'package:smoke_buddy/screens/forums/comments.dart';
import 'package:smoke_buddy/screens/forums/liked.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/screens/wallpapers/extended-wallpaper.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:smoke_buddy/widgets/video-widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'custom-text.dart';

class PostWidget extends StatefulWidget {

  final String name;
  final String date;
  final String description;
  final String proPic;
  final String image;
  final String video;
  final String uid;
  final String authorId;
  final List likes;
  final List following;
  final String postId;
  final String thumbnail;

  const PostWidget({Key key, this.name, this.date, this.proPic, this.image, this.description, this.uid, this.authorId, this.likes, this.following, this.postId, this.video, this.thumbnail}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {

  bool liked = false;
  bool followed = false;
  List<DocumentSnapshot> comments;
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<QuerySnapshot> subscriptionAuthor;
  String proPic = "";
  String name = "loading";


  getComments(String postID)async{
    subscription = FirebaseFirestore.instance.collection('posts').doc(postID).collection('comments').orderBy('time',descending: true).snapshots().listen((datasnapshot){
      setState(() {
        comments = datasnapshot.docs;
      });
    });
  }

  getAuthorDetails() async {
    subscriptionAuthor = FirebaseFirestore.instance.collection('users').where('id', isEqualTo: widget.authorId).snapshots().listen((datasnapshot){
      setState(() {
        var user = datasnapshot.docs;
        proPic = user[0]['proPic'];
        name = user[0]['name'];
      });
    });
  }

  getCommentedUserData(String id) async {
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: id).get();
    var users = sub.docs;
    if(users.isNotEmpty){
      Map x = {
        'proPic': users[0]['proPic'],
        'userName': users[0]['name']
      };
      return x;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments(widget.postId);
    getAuthorDetails();
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
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
    subscriptionAuthor?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      key: UniqueKey(),
      decoration: BoxDecoration(
          color: Constants.kFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3,color: Constants.kFillOutlineColor)
      ),
      child: Column(
        children: [

          ///propic and name
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(proPic),
            ),
            title: CustomText(text: widget.uid==widget.authorId?'Me':name,align: TextAlign.start,),
            subtitle: CustomText(text: widget.date,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
            onTap: (){
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Profile(uid: widget.authorId,)),
              );
            },
            trailing: widget.uid==widget.authorId
                ?
            IconButton(
              icon: Icon(Icons.delete,color: Colors.black,),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: CustomText(text: 'Delete Post',),
                      content: CustomText(text: 'Are you sure you want to delete the post?',isBold: false,),
                      actions: [
                        TextButton(onPressed: () async {
                          try{
                            await FirebaseFirestore.instance.collection('posts').doc(widget.postId).delete();
                            ToastBar(text: 'Post deleted!',color: Colors.green).show(context);
                            subscription.cancel();
                            getComments(widget.postId);
                            Navigator.pop(context);
                          }
                          catch(e){
                            ToastBar(text: 'Something went wrong',color: Colors.red).show(context);
                          }
                        }, child: CustomText(text: "YES",)),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: CustomText(text: "NO",)),
                      ],
                    );
                  },
                );
              },
            )
                :
            IconButton(
              icon: Icon(CupertinoIcons.exclamationmark_bubble_fill,color: Colors.black,),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: CustomText(text: 'Report Post',),
                      content: CustomText(text: 'Are you sure you want to report this post?',isBold: false,),
                      actions: [
                        TextButton(onPressed: () async {
                          try{
                            await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                              'report': 'pending'
                            });
                            ToastBar(text: 'Report Sent!',color: Colors.green).show(context);
                            Navigator.pop(context);
                          }
                          catch(e){
                            ToastBar(text: 'Something went wrong',color: Colors.red).show(context);
                          }
                        }, child: CustomText(text: "YES",)),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: CustomText(text: "NO",)),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          ///text
          if(widget.description!='')
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: Linkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                await launch(link.url);
                } else {
                ToastBar(text: 'Could not launch url!',color: Colors.red).show(context);
                }
              },
              style: TextStyle(
                  color: Constants.kMainTextColor,
                  fontSize: ScreenUtil().setSp(35),
                  letterSpacing: 0.6,
                  fontFamily: 'Antonio',
              ),
              textAlign: TextAlign.start,
              text: widget.description,

            ),
          ),
          // CustomText(
          //   text: widget.description,
          //   align: TextAlign.start,
          //   isBold: false,
          //   size: ScreenUtil().setSp(35),
          // )

          ///image
          Visibility(
            visible: widget.image!='',
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2
                ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: 0,wallpapers: [{'url': widget.image}],isDownloadable: false,)),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.fitHeight,
                    placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                  ),
                ),
              ),
            ),
          ),

          ///video
          if(widget.video!='')
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => VideoWidget(url: widget.video,)),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.thumbnail,
                    fit: BoxFit.fitHeight,
                    placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                  ),
                  Icon(Icons.play_circle_fill,size: ScreenUtil().setHeight(120),color: Colors.white,),
                ],
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
                      setState(() {
                        liked=true;
                      });
                      likes.add(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'likes': likes
                      });

                      ///send notifications
                      NotificationModel.sendLikeNotification(postID: widget.postId,receiverID: widget.authorId,following: widget.following);


                    }
                    else{
                      setState(() {
                        liked=false;
                      });
                      likes.remove(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'likes': likes
                      });

                    }
                    },

                  onLongPress: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => LikedUsers(likeList: widget.likes,uid: widget.uid,)),
                    );
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
                      MaterialPageRoute(builder: (context) => Comments(postID: widget.postId,authorID: widget.authorId,following: widget.following,likes: widget.likes,)),
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
                    setState(() {
                      followed=true;
                    });
                    List following = widget.following;

                    if(!widget.following.contains(widget.uid)){
                      following.add(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'following': following
                      });

                      ///send notification
                      await NotificationModel.sendFollowNotification(receiverID: widget.authorId,postID: widget.postId);


                    }
                    else{
                      setState(() {
                        followed=false;
                      });
                      following.remove(widget.uid);
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                        'following': following
                      });

                    }
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(followed?Icons.notifications_active:Icons.notifications_none, color: followed?Color(0xff77983d):Colors.black,),
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
            FutureBuilder(
              future: getCommentedUserData(comments[0]['authorID']),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: CachedNetworkImage(imageUrl: snapshot.data['proPic'], width: ScreenUtil().setHeight(160),height: ScreenUtil().setHeight(160),fit: BoxFit.fitWidth,),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                      dense: true,
                      isThreeLine: true,
                      title: CustomText(text: comments[0]['authorID']==widget.uid?'Me':snapshot.data['userName'],align: TextAlign.start,),
                      subtitle: CustomText(text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(comments[0]['time']))+'\n'+comments[0]['comment'],align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
                    ),
                  );
                }
                else{
                  return Container();
                }

              },
            ),


        ],
      ),
    );
  }
}
