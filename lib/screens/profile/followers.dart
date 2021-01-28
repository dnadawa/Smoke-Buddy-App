import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smoke_buddy/screens/profile/profile.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

class Followers extends StatefulWidget {

  final List followers;
  final ScrollController scrollController;

  const Followers({Key key, this.followers, this.scrollController}) : super(key: key);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {

  getData(String userID) async {
    var sub = await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: userID).get();
    var users = sub.docs;
     String proPic = users[0]['proPic'];
     String name = users[0]['name'];
     Map map = {
       'name': name,
       'image': proPic
     };
     // print(map);
     return map;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: widget.followers!=null?ListView.builder(
        itemCount: widget.followers.length,
        controller: widget.scrollController,
        itemBuilder: (context,i){

          return FutureBuilder(
            future: getData(widget.followers[i]),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(snapshot.data['image']),
                  ),
                  title: CustomText(text: snapshot.data['name'],align: TextAlign.start,),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile(uid: widget.followers[i],)),
                    );
                  },
                );
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
              },
          );
          },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
