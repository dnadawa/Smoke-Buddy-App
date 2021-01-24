import 'package:flutter/material.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: 'Dulaj Nadawa',align: TextAlign.start,),
          ),
          ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: 'Dulaj Nadawa',align: TextAlign.start,),
          ),
        ],
      ),
    );
  }
}
