import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/drawer.dart';
import 'package:smoke_buddy/screens/forums/posts.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/screens/wallpapers/wallpaper-feed.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/tab-button.dart';

import '../../constants.dart';

class Wallpapers extends StatefulWidget {
  static TabController tabController;

  final int index;

  const Wallpapers({Key key, this.index}) : super(key: key);

  @override
  _WallpapersState createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers>  with SingleTickerProviderStateMixin{
  // TabController _tabController;
  bool t1;
  bool t2;
  bool t3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wallpapers.tabController = TabController(length: 3, vsync: this,initialIndex: widget.index);
    Wallpapers.tabController.addListener(() {
      print('index is: '+Wallpapers.tabController.index.toString());
      setState(() {
        switch(Wallpapers.tabController.index){
          case 0:{t1=true;t2=false;t3=false;}break;
          case 1:{t1=false;t2=true;t3=false;}break;
          case 2:{t1=false;t2=false;t3=true;}break;
          default:{t1=false;t2=false;t3=false;}break;
        }
      });
    });

    switch(widget.index){
      case 0:{t1=true;t2=false;t3=false;}break;
      case 1:{t1=false;t2=true;t3=false;}break;
      case 2:{t1=false;t2=false;t3=true;}break;
      default:{t1=false;t2=false;t3=false;}break;
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
          child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Home()),
                );
              },
              child: Image.asset('assets/images/appbar.png')),
        ),
        bottom: TabBar(
          controller: Wallpapers.tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(25)),
          onTap: (i){
            setState(() {
              switch(i){
                case 0:{t1=true;t2=false;t3=false;}break;
                case 1:{t1=false;t2=true;t3=false;}break;
                case 2:{t1=false;t2=false;t3=true;}break;
                default:{t1=false;t2=false;t3=false;}break;
              }
            });
          },
          tabs: [
            TabButton(name: 'ARTISTS',image: 'artists.png',selected: t1,),
            TabButton(name: 'CHRISTIANIA',image: 'christiania.png',selected: t2,),
            TabButton(name: 'SMOKEBUDDY',image: 'smokebuddy.png',selected: t3,),
          ],
        ),
      ),
      drawer: Drawer(
        child: MenuDrawer(controller: Wallpapers.tabController,screen: 'wallpapers',),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: TabBarView(
          controller: Wallpapers.tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            WallpaperFeed(category: 'ARTISTS',),
            WallpaperFeed(category: 'CHRISTIANIA',),
            WallpaperFeed(category: 'SMOKEBUDDY',),
          ],
        ),
      ),
      bottomSheet: AppBottomSheet(),
    );
  }
}
