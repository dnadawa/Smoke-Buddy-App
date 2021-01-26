import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  const Register({Key key, this.uid, this.phone}) : super(key: key);
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

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        ToastBar(text: 'No image selected',color: Colors.red).show();
      }
    });
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

                      if(accept){
                        ToastBar(text: 'Please wait',color: Colors.orange).show();
                        if(username.text.isNotEmpty&&status.text.isNotEmpty&&email.text.isNotEmpty&&image!=null){
                          String gender;
                          switch(_gender.index){
                            case 0:gender='male';break;
                            case 1:gender="female";break;
                            case 2:gender="other";break;
                          }

                          try{
                            TaskSnapshot snap = await storage.ref('users_profiles/'+widget.uid).putFile(image);
                            String url = await snap.ref.getDownloadURL();

                            await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
                              'id': widget.uid,
                              'name': username.text,
                              'status': status.text,
                              'email': email.text,
                              'phoneNumber': widget.phone,
                              'gender': gender,
                              'proPic': url,
                              'hide': false,
                              'notifyOwnPosts': true,
                              'notifyOtherPosts': true
                            });

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('uid', widget.uid);

                            ToastBar(text: 'Registered Successfully!',color: Colors.green).show();

                            Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (context) =>
                                    Home()), (Route<dynamic> route) => false);

                          }
                          catch(e){
                            print(e.toString());
                            ToastBar(text: 'Something went wrong!',color: Colors.red).show();
                          }

                        }
                        else{
                          ToastBar(text: 'Please fill all fields!',color: Colors.red).show();
                        }


                      }
                      else{
                        ToastBar(text: 'You must accept terms and conditions to continue',color: Colors.red).show();
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
