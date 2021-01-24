import 'package:flutter/material.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: 'Sanjula Hasaranga',align: TextAlign.start,),
          ),
          ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: 'Sanjula Hasaranga',align: TextAlign.start,),
          ),
        ],
      ),
    );
  }
}
