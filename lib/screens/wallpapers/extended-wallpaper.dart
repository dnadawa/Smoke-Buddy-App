import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExtendedWallpaper extends StatefulWidget {

  final int index;

  const ExtendedWallpaper({Key key, this.index}) : super(key: key);

  @override
  _ExtendedWallpaperState createState() => _ExtendedWallpaperState();
}

class _ExtendedWallpaperState extends State<ExtendedWallpaper> {

  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.download_rounded,color: Theme.of(context).primaryColor,),
      ),
      body: Hero(
        tag: widget.index,
        child: PageView(
          controller: controller,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy.jpg?alt=media&token=70b33e81-438b-4851-9d2b-81ae9ca1aec3',
                fit: BoxFit.fill,
                placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%204.jpg?alt=media&token=0f036abd-f944-4887-a3ee-1b6afaffbef5',
                fit: BoxFit.fill,
                placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%202.jpg?alt=media&token=c67f4ddd-3989-432c-a9f3-1bbd53f96bec',
                fit: BoxFit.fill,
                placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://firebasestorage.googleapis.com/v0/b/smokebuddy-5b82c.appspot.com/o/Wallpapers%2Fsmokebuddy%203.jpg?alt=media&token=7ab6c4cf-96e8-438e-85e9-21293e20fc08',
                fit: BoxFit.fill,
                placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
