import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smoke_buddy/screens/auth/password-reset-otp.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

class EditProfile extends StatefulWidget {

  final String uid;

  const EditProfile({Key key, this.uid}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController name = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController email = TextEditingController();
  List<DocumentSnapshot> user;
  StreamSubscription<QuerySnapshot> subscription;
  String image = '';
  File pickedImage;

  getData(){
    subscription = FirebaseFirestore.instance.collection('users').where('id', isEqualTo: widget.uid).snapshots().listen((datasnapshot){
      setState(() {
        user = datasnapshot.docs;
        name.text = user[0]['name'];
        status.text = user[0]['status'];
        image = user[0]['proPic'];
        email.text = user[0]['email'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
        title: CustomText(text: 'EDIT PROFILE',color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding:  EdgeInsets.only(top: ScreenUtil().setHeight(100)),
          child: Stack(
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(40),ScreenUtil().setHeight(80),ScreenUtil().setHeight(40),0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.kFillColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Constants.kFillOutlineColor,width: 3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      
                      ///name
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: InputField(
                          hint: 'SmokeBuddy Name',
                          isLabel: true,
                          controller: name,
                        ),
                      ),

                      ///email
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: InputField(
                          hint: 'Email',
                          isLabel: true,
                          controller: email,
                          enabled: false,
                        ),
                      ),
                      
                      ///status
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: InputField(
                          hint: 'SmokeBuddy Status',
                          isLabel: true,
                          controller: status,
                        ),
                      ),

                      ///forget password
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                        child: GestureDetector(
                          onTap: () async {
                            var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: widget.uid).get();
                            var users = sub.docs;

                            if(users[0]['phoneNumber']==''){
                              ToastBar(text: 'Please wait',color: Colors.orange).show(context);
                              FirebaseAuth auth = FirebaseAuth.instance;
                              await auth.sendPasswordResetEmail(email: users[0]['email']);
                              ToastBar(text: 'Password reset link sent to your email!',color: Colors.green).show(context);
                            }
                            else{
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => PasswordResetOTP(phone: users[0]['phoneNumber'],uid: users[0]['id'],)),
                              );
                            }

                          },
                          child: CustomText(
                            text: 'CHANGE PASSWORD',
                          ),
                        ),
                      ),
                      
                      ///button
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: SizedBox(
                          width: ScreenUtil().setWidth(400),
                          height: ScreenUtil().setHeight(100),
                          child: Button(
                            text: 'SAVE',
                            onPressed: () async {
                              ToastBar(text: 'Please wait',color: Colors.orange).show(context);

                              ///check user exists
                              var sub = await FirebaseFirestore.instance.collection('users').where('name', isEqualTo: name.text).get();
                              var users = sub.docs;
                              if(users.isNotEmpty){
                                if(users[0]['id']==widget.uid){
                                  await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                                    'name': name.text,
                                    'status': status.text,
                                    'proPic': image
                                  });
                                  ToastBar(text: 'Account updated!',color: Colors.green).show(context);
                                }
                                else{
                                  ToastBar(text: 'NAME ALREADY IN USE',color: Colors.red).show(context);
                                }
                              }
                              else{
                                await FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
                                  'name': name.text,
                                  'status': status.text,
                                  'proPic': image
                                });
                                ToastBar(text: 'Account updated!',color: Colors.green).show(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              ///pro pic
              Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: ()async {
                      FirebaseStorage storage = FirebaseStorage.instance;
                      final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
                      if (pickedFile != null) {
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: pickedFile.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                            compressFormat: ImageCompressFormat.png,
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: 'Crop Image',
                                toolbarColor: Theme.of(context).primaryColor,
                                activeControlsWidgetColor: Theme.of(context).accentColor,
                                initAspectRatio: CropAspectRatioPreset.square,
                                lockAspectRatio: true
                            ),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            )
                        );
                        pickedImage = File(croppedFile.path);
                      } else {
                          ToastBar(text: 'No image selected',color: Colors.red).show(context);
                      }
                      ToastBar(text: 'Uploading...',color: Colors.orange).show(context);
                      TaskSnapshot snap = await storage.ref('users_profiles/'+DateTime.now().millisecondsSinceEpoch.toString()).putFile(pickedImage);
                      image = await snap.ref.getDownloadURL();
                      setState(() {});
                      ToastBar(text: 'Image uploaded!',color: Colors.green).show(context);
                      imageCache.maximumSize = 0;
                      imageCache.clear();
                      },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(image),
                      radius: ScreenUtil().setHeight(80),
                    ),
                  )
              )
            ],
          ),
        ),
      ),


      bottomNavigationBar: AppBottomSheet(),
    );
  }
}
