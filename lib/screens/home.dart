import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smoke_buddy/screens/forums/forums.dart';
import 'package:smoke_buddy/screens/wallpapers/wallpapers.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../notification-model.dart';
import 'auth/phone-login.dart';
import 'notifications/notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  checkBan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: uid).get();
    var user = sub.docs;
    bool isBan = user[0]['ban'];
    if(isBan){
      ToastBar(text: 'You have banned from the app',color: Colors.red).show();
      await FirebaseAuth.instance.signOut();
      prefs.setString('uid', null);
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) =>
              PhoneLogin()), (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationModel.setPlayerID();
    checkBan();
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('getting notification');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => Notifications()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              ///logo
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.04),
                child: Image.asset('assets/images/logo.png'),
              ),
              // SizedBox(height: ScreenUtil().setHeight(10)),

              ///forums
              Button(
                text: 'FORUMS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Forums(index: 0,)),
                  );
                },
                image: 'forums.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///notifications
              Button(
                text: 'NOTIFICATIONS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Notifications()),
                  );
                },
                image: 'notifications.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///wallpapers
              Button(
                text: 'WALLPAPERS',
                onPressed: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Wallpapers(index: 0,)),
                  );
                },
                image: 'wallpapers.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///shop
              Button(
                text: 'SHOP',
                onPressed: () async => await launch('https://www.smokebuddy.eu/'),
                image: 'shop.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///game
              Button(
                text: 'GAME',
                onPressed: () async => await launch('https://www.smokebuddy.eu/smokebuddy-world'),
                image: 'game.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


              ///blog
              Button(
                text: 'BLOG',
                onPressed: () async => await launch('https://www.smokebuddy.eu/blogs'),
                image: 'blog.png',
                leadingImage: true,
              ),
              SizedBox(height: ScreenUtil().setHeight(30),),


            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomSheet(),
    );
  }
}
