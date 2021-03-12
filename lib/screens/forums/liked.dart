import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';

class LikedUsers extends StatefulWidget {
  final List likeList;
  final String uid;

  const LikedUsers({Key key, this.likeList, this.uid}) : super(key: key);
  @override
  _LikedUsersState createState() => _LikedUsersState();
}

class _LikedUsersState extends State<LikedUsers> {

  List userDetails = [];
  
  getUsers() async {
    for(int i=0;i<widget.likeList.length;i++){
      var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: widget.likeList[i]).get();
      var user = sub.docs;
      userDetails.add(user[0]);
    }
    setState(() {});
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'LIKES',
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
        child: userDetails!=null?ListView.builder(
          itemCount: userDetails.length,
          itemBuilder: (context,i){
            print("printing"+userDetails[i]['proPic'].toString());
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(userDetails[i]['proPic']),
              ),
              title: CustomText(text: widget.uid==userDetails[i]['id']?'Me':userDetails[i]['name'],align: TextAlign.start,),
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Profile(uid: userDetails[i]['id'],)),
                );
              },
            );
          },
        ):Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
