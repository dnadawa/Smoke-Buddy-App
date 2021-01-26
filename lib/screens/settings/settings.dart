import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/auth/phone-login.dart';
import 'package:smoke_buddy/screens/settings/about.dart';
import 'package:smoke_buddy/screens/settings/edit-profile.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool hideProfile=false,notifyOwnPosts=true,notifyOtherPosts=true;
  List<DocumentSnapshot> user;
  StreamSubscription<QuerySnapshot> subscription;
  String uid;
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');

    subscription = FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).snapshots().listen((datasnapshot){
      setState(() {
        user = datasnapshot.docs;
        hideProfile = user[0]['hide'];
        notifyOwnPosts = user[0]['notifyOwnPosts'];
        notifyOtherPosts = user[0]['notifyOtherPosts'];
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
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
        title: CustomText(text: 'SETTINGS',color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///logo
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                  child: Image.asset('assets/images/logo.png'),
                ),

                ///account
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                  child: CustomText(text: 'ACCOUNT',size: ScreenUtil().setSp(40),),
                ),

                ///edit profile
                ListTile(
                  title: CustomText(text: 'Edit Profile',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => EditProfile(uid: uid,)),
                    );
                  },
                ),

                ///hide profile
                ListTile(
                  title: CustomText(text: 'Hide Profile',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                      value: hideProfile,
                      onChanged: (val)async{
                        setState((){
                          hideProfile = val;
                        });

                        await FirebaseFirestore.instance.collection('users').doc(uid).update({
                          'hide': hideProfile
                        });

                      },
                      activeColor: Constants.kSwitchActiveColor,
                      trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),


                ///log out
                ListTile(
                  title: CustomText(text: 'Log Out',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    ToastBar(text: 'Please wait...',color: Colors.orange).show();
                    await FirebaseAuth.instance.signOut();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('uid', null);
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(builder: (context) =>
                            PhoneLogin()), (Route<dynamic> route) => false);
                    ToastBar(text: 'Logged out!',color: Colors.green).show();
                  },
                ),


                ///notifications
                Padding(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                  child: CustomText(text: 'NOTIFICATIONS',size: ScreenUtil().setSp(40),),
                ),

                ///own posts
                ListTile(
                  title: CustomText(text: 'Own Posts',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                    value: notifyOwnPosts,
                    onChanged: (val) async {
                      setState(() {
                        notifyOwnPosts = val;
                      });

                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'notifyOwnPosts': notifyOwnPosts
                      });

                    },
                    activeColor: Constants.kSwitchActiveColor,
                    trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),


                ///own posts
                ListTile(
                  title: CustomText(text: 'Other Posts',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: CupertinoSwitch(
                    value: notifyOtherPosts,
                    onChanged: (val) async {
                      setState(() {
                        notifyOtherPosts = val;
                      });

                      await FirebaseFirestore.instance.collection('users').doc(uid).update({
                        'notifyOtherPosts': notifyOtherPosts
                      });

                    },
                    activeColor: Constants.kSwitchActiveColor,
                    trackColor: Constants.kSwitchInactiveColor,
                  ),
                ),

                ///about
                ListTile(
                  title: CustomText(text: 'About',align: TextAlign.start,size: ScreenUtil().setSp(35),),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => About()),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
