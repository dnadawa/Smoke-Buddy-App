import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extended-wallpaper.dart';

class WallpaperFeed extends StatefulWidget {
  final String category;

  const WallpaperFeed({Key key, this.category}) : super(key: key);
  @override
  _WallpaperFeedState createState() => _WallpaperFeedState();
}

class _WallpaperFeedState extends State<WallpaperFeed> {
  List<DocumentSnapshot> wallpapers;
  StreamSubscription<QuerySnapshot> subscription;

  getWallpapers(){
    subscription = FirebaseFirestore.instance.collection('Wallpapers').where('category', isEqualTo: widget.category).snapshots().listen((datasnapshot){
      setState(() {
        wallpapers = datasnapshot.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallpapers();
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
      backgroundColor: Colors.transparent,
      body: wallpapers!=null?GridView.builder(
        itemCount: wallpapers.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9/14,
        ),
        padding: EdgeInsets.all(5),
        itemBuilder: (context,i){

          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: i,wallpapers: wallpapers,)),
              );
            },
            child: Hero(
              tag: i,
              child: Card(
                elevation: 5,
                child: CachedNetworkImage(
                  imageUrl: wallpapers[i]['url'],
                  fit: BoxFit.fill,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          );
        },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
