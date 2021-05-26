import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/notification-model.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

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


                    String id = comments[i]['authorID'];
                    String comment = comments[i]['comment'];
                    String time = comments[i]['time'];

                    return FutureBuilder(
                      future: getCommentedUserData(id),
                      builder: (context, snapshot){
                        if(snapshot.hasData) {
                          String proPic = snapshot.data['proPic'];
                          String name = snapshot.data['userName'];

                          return ListTile(
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) =>
                                    Profile(uid: comments[i]['authorID'],)),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                  proPic),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(10)),
                            title: CustomText(
                              text: name == userName ? 'Me' : name,
                              align: TextAlign.start,),
                            // subtitle: CustomText(text: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(time))+'\n'+comment,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
                            subtitle: Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  ToastBar(text: 'Could not launch url!',
                                      color: Colors.red).show(context);
                                }
                              },
                              style: TextStyle(
                                color: Constants.kMainTextColor,
                                fontSize: ScreenUtil().setSp(25),
                                letterSpacing: 0.6,
                                fontFamily: 'Antonio',
                              ),
                              textAlign: TextAlign.start,
                              text: DateFormat('dd/MM/yyyy HH:mm').format(
                                  DateTime.parse(time)) + '\n' + comment,

                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                      },
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
                            ToastBar(text: 'Commenting...',color: Colors.orange).show(context);
                            await FirebaseFirestore.instance.collection('posts').doc(widget.postID).collection('comments').add({
                              'time': DateTime.now().toString(),
                              'comment': comment.text,
                              'authorName': userName,
                              'authorImage': proPic,
                              'authorID': uid,
                            });

                            ///sendNotification
                            NotificationModel.sendCommentNotification(postID: widget.postID,receiverID: widget.authorID,following: widget.following, likes: widget.likes, comments: commentersIDs);

                            ToastBar(text: 'Comment added!',color: Colors.green).show(context);
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
