import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/toast.dart';

import '../../constants.dart';

class BanUsers extends StatefulWidget {
  @override
  _BanUsersState createState() => _BanUsersState();
}

class _BanUsersState extends State<BanUsers> {

  List<DocumentSnapshot> users;
  StreamSubscription<QuerySnapshot> subscription;

  getUsers(){
    subscription = FirebaseFirestore.instance.collection('users').orderBy('name').snapshots().listen((datasnapshot){
      setState(() {
        users = datasnapshot.docs;
      });
    });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
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
        title: SizedBox(
          width: ScreenUtil().setWidth(430),
          child: Image.asset('assets/images/appbar.png'),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: users!=null?ListView.builder(
            itemCount: users.length,
            itemBuilder: (context,i){
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(users[i]['proPic']),
                ),
                title: CustomText(text: users[i]['name'],align: TextAlign.start,),
                trailing: TextButton(
                  child: CustomText(text: users[i]['ban']?'UNBAN':'BAN',),
                  onPressed: ()async{
                    if(users[i]['ban']){
                      await FirebaseFirestore.instance.collection('users').doc(users[i].id).update({
                        'ban': false
                      });
                      ToastBar(text: 'User Unbanned!',color: Colors.green).show(context);
                    }
                    else{
                      await FirebaseFirestore.instance.collection('users').doc(users[i].id).update({
                        'ban': true
                      });
                      ToastBar(text: 'User Banned!',color: Colors.green).show(context);
                    }
                  },
                ),
              );
            },
        ):
        Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
