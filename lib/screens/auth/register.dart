import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class Register extends StatefulWidget {
  final String uid;
  final String phone;
  final String email;
  final String password;

  const Register({Key key, this.uid, this.phone, this.email, this.password}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

enum Gender { male, female, other }

class _RegisterState extends State<Register> {
  Gender _gender = Gender.male;
  bool accept = false;
  TextEditingController username = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController email = TextEditingController();
  File image;
  FirebaseStorage storage = FirebaseStorage.instance;
  String uid;

  Future getImage() async {
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
        image = File(croppedFile.path);
      } else {
        ToastBar(text: 'No image selected',color: Colors.red).show(context);
      }
    setState(() {});
    imageCache.maximumSize = 0;
    imageCache.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid=widget.uid;
    email.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'REGISTER',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///upload photo
              Center(
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(60)),
                  child: GestureDetector(
                    onTap: ()=>getImage(),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Constants.kFillColor,
                      backgroundImage: image==null?null:FileImage(image),
                      child: image==null?Icon(
                        Icons.camera_alt,
                        color: Constants.kMainTextColor,
                        size: 35,
                      ):Container(),
                    ),
                  ),
                ),
              ),

              ///form
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Username',
                  controller: username,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Status',
                  controller: status,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: InputField(
                  hint: 'Email',
                  type: TextInputType.emailAddress,
                  controller: email,
                ),
              ),

              ///radios
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: CustomText(
                    text: 'Please select your gender',
                    size: ScreenUtil().setSp(35)),
              ),

              ///male
              RadioListTile(
                value: Gender.male,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Male',
                  align: TextAlign.start,
                ),
              ),
              ///female
              RadioListTile(
                value: Gender.female,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Female',
                  align: TextAlign.start,
                ),
              ),
              ///other
              RadioListTile(
                value: Gender.other,
                activeColor: Constants.kMainTextColor,
                groupValue: _gender,
                dense: true,
                onChanged: (val) {
                  setState(() {
                    _gender = val;
                  });
                },
                title: CustomText(
                  text: 'Other',
                  align: TextAlign.start,
                ),
              ),


              ///terms and conditions
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              CheckboxListTile(
                  value: accept,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Constants.kMainTextColor,
                  onChanged: (val){
                    setState(() {
                      accept = val;
                    });
                  },
                  title: GestureDetector(
                    onTap: () async =>await launch('https://www.smokebuddy.eu/pages/privacy-policy'),
                    child: CustomText(text: 'I accept all terms and conditions',align: TextAlign.start,),
                  ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),


              ///button
              Center(
                child: SizedBox(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(100),
                  child: Button(
                    text: 'SAVE',
                    onPressed: () async {
                      String finalPassword = widget.password;
                      if(accept){
                        ToastBar(text: 'Please wait',color: Colors.orange).show(context);
                        if(username.text.isNotEmpty&&status.text.isNotEmpty&&email.text.isNotEmpty){
                          String gender;
                          switch(_gender.index){
                            case 0:gender='male';break;
                            case 1:gender="female";break;
                            case 2:gender="other";break;
                          }

                          try{

                            ///check user exists
                            var sub = await FirebaseFirestore.instance.collection('users').where('name', isEqualTo: username.text).get();
                            var users = sub.docs;

                            ///check email exists
                            var sub2 = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email.text).get();
                            var user = sub2.docs;


                            if(users.isNotEmpty){
                              ToastBar(text: 'NAME ALREADY IN USE',color: Colors.orange).show(context);
                            }
                            else if(user.isNotEmpty){
                              ToastBar(text: 'EMAIL ALREADY IN USE',color: Colors.orange).show(context);
                            }
                            else{
                              ///auth using email
                              if(widget.email!=''){
                                finalPassword = "";
                                try {
                                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: widget.email,
                                      password: widget.password
                                  );

                                  uid = userCredential.user.uid;
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    ToastBar(text: 'The password provided is too weak',color: Colors.red).show(context);
                                  } else if (e.code == 'email-already-in-use') {
                                    ToastBar(text: 'The account already exists for that email',color: Colors.red).show(context);
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }


                              ///image upload
                              String url = 'https://www.kindpng.com/picc/m/22-223965_no-profile-picture-icon-circle-member-icon-png.png';
                              if(image!=null){
                                TaskSnapshot snap = await storage.ref('users_profiles/'+uid).putFile(image);
                                url = await snap.ref.getDownloadURL();
                              }


                              await FirebaseFirestore.instance.collection('users').doc(uid).set({
                                'id': uid,
                                'name': username.text,
                                'status': status.text,
                                'email': email.text,
                                'phoneNumber': widget.phone,
                                'gender': gender,
                                'proPic': url,
                                'hide': false,
                                'notifyOwnPosts': true,
                                'notifyOtherPosts': true,
                                'following': ['sxdu6NkXuceOCJHzZWgQqDZQhfx2'],
                                'followers': [],
                                'ban': false,
                                'password': finalPassword
                              });

                              await FirebaseFirestore.instance.collection('users').doc('sxdu6NkXuceOCJHzZWgQqDZQhfx2').update({
                                'followers': FieldValue.arrayUnion([uid])
                              });


                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('uid', uid);

                              ToastBar(text: 'Registered Successfully!',color: Colors.green).show(context);

                              Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(builder: (context) =>
                                      Home()), (Route<dynamic> route) => false);
                            }


                          }
                          catch(e){
                            print(e.toString());
                            ToastBar(text: 'Something went wrong!',color: Colors.red).show(context);
                          }

                        }
                        else{
                          ToastBar(text: 'Please fill all fields!',color: Colors.red).show(context);
                        }


                      }
                      else{
                        ToastBar(text: 'You must accept terms and conditions to continue',color: Colors.red).show(context);
                      }






                    },
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
