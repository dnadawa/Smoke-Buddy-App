import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
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
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import 'custom-text.dart';

class AdminPostWidget extends StatefulWidget {

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

  const AdminPostWidget({Key key, this.name, this.date, this.proPic, this.image, this.description, this.uid, this.authorId, this.likes, this.following, this.postId, this.video}) : super(key: key);

  @override
  _AdminPostWidgetState createState() => _AdminPostWidgetState();
}

class _AdminPostWidgetState extends State<AdminPostWidget> {

  bool isVideoLoading = true;

  VideoPlayerController _controller;
  ChewieController chewieController;




  initVideo()async{
    if(widget.video.isNotEmpty){
      _controller = VideoPlayerController.network(widget.video);
      await _controller.initialize();
      chewieController = ChewieController(
        autoPlay: false,
        looping: false,
        videoPlayerController: _controller,
        autoInitialize: true
      );
      setState(() {
        isVideoLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ///initializing video
    initVideo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chewieController.dispose();
    _controller.dispose();
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
              backgroundImage: CachedNetworkImageProvider(widget.proPic),
            ),
            title: CustomText(text: widget.uid==widget.authorId?'Me':widget.name,align: TextAlign.start,),
            subtitle: CustomText(text: widget.date,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
            onTap: (){
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Profile(uid: widget.authorId,)),
              );
            },
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

          ///image
          Visibility(
            visible: widget.image!='',
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height/2
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.fitHeight,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          ),

          ///video
          Visibility(
            visible: widget.video!='',
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Container(
                height: MediaQuery.of(context).size.height/3,
                // child: !isVideoLoading?Chewie(controller: chewieController):Image.asset('assets/images/loading.gif'),
                child:
                BetterPlayer.network(
                  widget.video,
                  betterPlayerConfiguration: BetterPlayerConfiguration(
                    looping: false,
                    autoPlay: false,
                  ),
                ),
              ),
            ),
          ),


          ///buttons
          Padding(
            padding:  EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Row(
              children: [
                Expanded(
                  child: Button(
                    text: 'Remove Post',
                    color: Colors.red,
                    fontSize: 25,
                    onPressed: (){},
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(10),),
                Expanded(
                  child: Button(
                    text: 'Discard Report',
                    fontSize: 25,
                    onPressed: (){},
                  ),
                )
              ],
            ),
          ),


        ],
      ),
    );
  }
}
