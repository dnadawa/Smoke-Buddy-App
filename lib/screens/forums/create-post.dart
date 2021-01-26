import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

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
  TextEditingController post = TextEditingController();

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
                                final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                                setState(() {
                                  if (pickedFile != null) {
                                    image = File(pickedFile.path);
                                  } else {
                                    ToastBar(text: 'No image selected',color: Colors.red).show();
                                  }
                                });
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
                            hintText: "What's on your mind...",
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
                        ToastBar(text: 'Posting...',color: Colors.orange).show();
                        String url='';
                        if(image!=null){
                          TaskSnapshot snap = await FirebaseStorage.instance.ref('post_images/${widget.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}').putFile(image);
                          url = await snap.ref.getDownloadURL();
                        }


                        await FirebaseFirestore.instance.collection('posts').add({
                          'authorID': widget.uid,
                          'authorName': widget.name,
                          'post': post.text,
                          'image': url,
                          'publishedDate': DateTime.now().toString(),
                          'likes': [],
                          'following': [],
                          'category': widget.category
                        });
                        ToastBar(text: 'Posted',color: Colors.green).show();
                        Navigator.pop(context);
                      }
                      catch(e){
                        ToastBar(text: 'Something went wrong',color: Colors.red).show();
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
