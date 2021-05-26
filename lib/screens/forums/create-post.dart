import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../constants.dart';
import '../../notification-model.dart';
import 'forums.dart';

class CreatePost extends StatefulWidget {

  final String proPic;
  final String category;
  final String uid;
  final String name;

  const CreatePost({Key key, this.proPic, this.category, this.uid, this.name}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  File image;
  File video;
  TextEditingController post = TextEditingController();
  VideoPlayerController _controller;
  ChewieController chewieController;

  @override
  void dispose() {
    // TODO: implement dispose
    chewieController.dispose();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'CREATE POST',
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constants.kFillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Constants.kFillOutlineColor,width: 2)
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          ///profile
                          Expanded(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(widget.proPic),
                              ),
                              title: CustomText(text: widget.name,align: TextAlign.start,),
                            ),
                          ),

                          ///picker
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                            child: GestureDetector(
                              onTap: () async {
                                ///show image video popup
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context)=>
                                        CupertinoActionSheet(
                                          actions: [
                                            CupertinoActionSheetAction(
                                                onPressed: ()async{
                                                  Navigator.pop(context);
                                                  showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (context)=>
                                                          CupertinoActionSheet(
                                                            actions: [
                                                              CupertinoActionSheetAction(
                                                                  onPressed: ()async{
                                                                    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 50);
                                                                    setState(() {
                                                                      if (pickedFile != null) {
                                                                        image = File(pickedFile.path);
                                                                        video = null;
                                                                      } else {
                                                                        ToastBar(text: 'No image selected',color: Colors.red).show(context);
                                                                      }
                                                                    });
                                                                    Navigator.pop(context);
                                                                    imageCache.maximumSize = 0;
                                                                    imageCache.clear();
                                                                  },
                                                                  child: CustomText(text: 'Camera',)
                                                              ),

                                                              CupertinoActionSheetAction(
                                                                  onPressed: () async {
                                                                    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
                                                                    setState(() {
                                                                      if (pickedFile != null) {
                                                                        image = File(pickedFile.path);
                                                                        video=null;
                                                                      } else {
                                                                        ToastBar(text: 'No image selected',color: Colors.red).show(context);
                                                                      }
                                                                    });
                                                                    Navigator.pop(context);
                                                                    imageCache.maximumSize = 0;
                                                                    imageCache.clear();
                                                                  },
                                                                  child: CustomText(text: 'Gallery',)
                                                              )

                                                            ],

                                                            cancelButton: CupertinoActionSheetAction(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: CustomText(text: 'Cancel',)
                                                            ),
                                                          )
                                                  );
                                                },
                                                child: CustomText(text: 'Image',)
                                            ),

                                            CupertinoActionSheetAction(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  showCupertinoModalPopup(
                                                      context: context,
                                                      builder: (context)=>
                                                          CupertinoActionSheet(
                                                            actions: [
                                                              CupertinoActionSheetAction(
                                                                  onPressed: ()async{
                                                                    final pickedFile = await ImagePicker().getVideo(source: ImageSource.camera);
                                                                    if (pickedFile != null) {
                                                                        video = File(pickedFile.path);
                                                                        image = null;
                                                                        _controller = VideoPlayerController.file(video);
                                                                        await _controller.initialize();
                                                                        chewieController = ChewieController(
                                                                            videoPlayerController: _controller,
                                                                            looping: false,
                                                                            autoPlay: false,
                                                                            aspectRatio: _controller.value.aspectRatio
                                                                        );
                                                                        setState(() {});
                                                                      } else {
                                                                        ToastBar(text: 'No video selected',color: Colors.red).show(context);
                                                                      }
                                                                    Navigator.pop(context);
                                                                    imageCache.maximumSize = 0;
                                                                    imageCache.clear();
                                                                  },
                                                                  child: CustomText(text: 'Camera',)
                                                              ),

                                                              CupertinoActionSheetAction(
                                                                  onPressed: () async {
                                                                    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);

                                                                      if (pickedFile != null) {
                                                                        video = File(pickedFile.path);
                                                                        image = null;
                                                                        _controller = VideoPlayerController.file(video);
                                                                        await _controller.initialize();
                                                                        chewieController = ChewieController(
                                                                            videoPlayerController: _controller,
                                                                            looping: false,
                                                                            autoPlay: false,
                                                                            aspectRatio: _controller.value.aspectRatio
                                                                        );
                                                                        setState(() {});
                                                                      } else {
                                                                        ToastBar(text: 'No video selected',color: Colors.red).show(context);
                                                                      }

                                                                    Navigator.pop(context);
                                                                    imageCache.maximumSize = 0;
                                                                    imageCache.clear();
                                                                  },
                                                                  child: CustomText(text: 'Gallery',)
                                                              )

                                                            ],

                                                            cancelButton: CupertinoActionSheetAction(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: CustomText(text: 'Cancel',)
                                                            ),
                                                          )
                                                  );
                                                },
                                                child: CustomText(text: 'Video',)
                                            )

                                          ],

                                          cancelButton: CupertinoActionSheetAction(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: CustomText(text: 'Cancel',)
                                          ),
                                        )
                                );





                                },
                              child: SizedBox(
                                  height: ScreenUtil().setHeight(60),
                                  child: Image.asset('assets/images/picker.png')
                              ),
                            ),
                          )
                        ],
                      ),


                      ///textfield
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        child: TextField(
                          style: Constants.kLoginTextStyle,
                          controller: post,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: widget.category!='gallery'?"Create a post":"Enter caption",
                            hintStyle: Constants.kLoginTextStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      ///image
                      Visibility(
                        visible: image!=null,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                          child: image!=null?Image.file(image):Container(),
                        ),
                      ),

                      ///video
                      Visibility(
                        visible: video!=null,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                          child: video!=null?
                              Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  child: Chewie(controller: chewieController))
                              :Container(),
                        ),
                      ),



                    ],
                  ),
                ),


                ///button
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(100),
                  child: Button(
                    text: 'POST',
                    onPressed: ()async{
                      try{
                        String imgUrl='';
                        String videoUrl='';
                        String videoThumbnail='';

                        ProgressDialog pr = ProgressDialog(context);
                        pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                        pr.style(
                            message: 'Uploading...',
                            borderRadius: 10.0,
                            backgroundColor: Colors.white,
                            progressWidget: Center(child: CircularProgressIndicator()),
                            elevation: 10.0,
                            insetAnimCurve: Curves.easeInOut,
                            messageTextStyle: TextStyle(
                                color: Colors.black, fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold)
                        );

                        await pr.show();
                        if(image!=null){
                          TaskSnapshot snap = await FirebaseStorage.instance.ref('post_images/${widget.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}').putFile(image);
                          imgUrl = await snap.ref.getDownloadURL();
                        }
                        if(video!=null){
                          ///upload video
                          TaskSnapshot snap = await FirebaseStorage.instance.ref('post_videos/${widget.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}').putFile(video);
                          videoUrl = await snap.ref.getDownloadURL();

                          ///generate thumbnail
                          String fileName = await VideoThumbnail.thumbnailFile(
                              video: video.path,
                              thumbnailPath: (await getTemporaryDirectory()).path,
                              imageFormat: ImageFormat.JPEG,
                              maxHeight: 250,
                              quality: 50,
                            );
                          File thumbnail = File(fileName);

                          ///upload thumbnail
                          TaskSnapshot snap2 = await FirebaseStorage.instance.ref('thumbnails/${widget.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}').putFile(thumbnail);
                          videoThumbnail = await snap2.ref.getDownloadURL();

                        }

                        print(imgUrl);
                        print(videoUrl);
                        if(widget.category=='gallery'&&(imgUrl.isEmpty&&videoUrl.isEmpty)){
                          ToastBar(text: 'Image or video is empty',color: Colors.red).show(context);
                          await pr.hide();
                        }
                        else{
                          var ref = await FirebaseFirestore.instance.collection('posts').add({
                            'authorID': widget.uid,
                            'authorName': widget.name,
                            'authorImage': widget.proPic,
                            'post': post.text,
                            'image': imgUrl,
                            'video': videoUrl,
                            'thumbnail': videoThumbnail,
                            'publishedDate': DateTime.now().toString(),
                            'likes': [],
                            'following': [],
                            'category': widget.category
                          });

                          ///send notification
                          NotificationModel.sendPostCreateNotification(author: widget.name,postID: ref.id);

                          pr.hide();
                          ToastBar(text: 'Posted',color: Colors.green).show(context);
                          Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(builder: (context) =>
                                  Forums(index: widget.category=='status'?0:widget.category=='gallery'?1:widget.category=='grow'?2:3,)), (Route<dynamic> route) => false);
                        }
                      }
                      catch(e){
                        ToastBar(text: 'Something went wrong',color: Colors.red).show(context);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
