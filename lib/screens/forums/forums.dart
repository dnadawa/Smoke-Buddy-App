import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/forums/posts.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/tab-button.dart';

import '../../constants.dart';

class Forums extends StatefulWidget {

  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums>  with SingleTickerProviderStateMixin{
  TabController _tabController;
  bool t1 = true;
  bool t2 = false;
  bool t3 = false;
  bool t4 = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(25)),
          onTap: (i){
            setState(() {
              switch(i){
                case 0:{t1=true;t2=false;t3=false;t4=false;}break;
                case 1:{t1=false;t2=true;t3=false;t4=false;}break;
                case 2:{t1=false;t2=false;t3=true;t4=false;}break;
                case 3:{t1=false;t2=false;t3=false;t4=true;}break;
                default:{t1=false;t2=false;t3=false;t4=true;}break;
              }
            });
          },
          tabs: [
            TabButton(name: 'STATUS',image: 'status.png',selected: t1,),
            TabButton(name: 'GALLERY',image: 'gallery.png',selected: t2,),
            TabButton(name: 'GROW',image: 'grow.png',selected: t3,),
            TabButton(name: 'COOKING',image: 'cooking.png',selected: t4,),
          ],
        ),
      ),
      drawer: Drawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Posts(),
            Posts(),
            Posts(),
            Posts(),
          ],
        ),
      ),
      bottomSheet: AppBottomSheet(),
    );
  }
}
