import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extended-wallpaper.dart';

class WallpaperFeed extends StatefulWidget {
  @override
  _WallpaperFeedState createState() => _WallpaperFeedState();
}

class _WallpaperFeedState extends State<WallpaperFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9/14,
        ),
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(5),
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: 0,)),
              );
            },
            child: Hero(
              tag: 0,
              child: Card(
                elevation: 5,
                child: CachedNetworkImage(
                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy.jpg?alt=media&token=70b33e81-438b-4851-9d2b-81ae9ca1aec3',
                  fit: BoxFit.fill,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: 1,)),
              );
            },
            child: Hero(
              tag: 1,
              child: Card(
                elevation: 5,
                child: CachedNetworkImage(
                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%204.jpg?alt=media&token=0f036abd-f944-4887-a3ee-1b6afaffbef5',
                  fit: BoxFit.fill,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
               MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: 2,)),
              );
            },
            child: Hero(
              tag: 2,
              child: Card(
                elevation: 5,
                child: CachedNetworkImage(
                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%202.jpg?alt=media&token=c67f4ddd-3989-432c-a9f3-1bbd53f96bec',
                  fit: BoxFit.fill,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExtendedWallpaper(index: 3,)),
              );
            },
            child: Hero(
              tag: 3,
              child: Card(
                elevation: 5,
                child: CachedNetworkImage(
                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%203.jpg?alt=media&token=7ab6c4cf-96e8-438e-85e9-21293e20fc08',
                  fit: BoxFit.fill,
                  placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
