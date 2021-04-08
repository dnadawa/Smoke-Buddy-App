import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/tab-button.dart';

import '../../constants.dart';
import 'admin-posts.dart';
import 'ban-users.dart';

class AdminForums extends StatefulWidget {

  static TabController tabController;
  final int index;

  const AdminForums({Key key, this.index}) : super(key: key);

  @override
  _AdminForumsState createState() => _AdminForumsState();
}

class _AdminForumsState extends State<AdminForums>  with SingleTickerProviderStateMixin{

  bool t1;
  bool t2;
  bool t3;
  bool t4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdminForums.tabController = TabController(length: 4, vsync: this, initialIndex: widget.index);
    AdminForums.tabController.addListener(() {
      print('index is: '+AdminForums.tabController.index.toString());
      setState(() {
        switch(AdminForums.tabController.index){
          case 0:{t1=true;t2=false;t3=false;t4=false;}break;
          case 1:{t1=false;t2=true;t3=false;t4=false;}break;
          case 2:{t1=false;t2=false;t3=true;t4=false;}break;
          case 3:{t1=false;t2=false;t3=false;t4=true;}break;
          default:{t1=false;t2=false;t3=false;t4=true;}break;
        }
      });
    });

    switch(widget.index){
      case 0:{t1=true;t2=false;t3=false;t4=false;}break;
      case 1:{t1=false;t2=true;t3=false;t4=false;}break;
      case 2:{t1=false;t2=false;t3=true;t4=false;}break;
      case 3:{t1=false;t2=false;t3=false;t4=true;}break;
      default:{t1=false;t2=false;t3=false;t4=true;}break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: ScreenUtil().setWidth(430),
          child: Image.asset('assets/images/appbar.png'),
        ),
        bottom: TabBar(
          controller: AdminForums.tabController,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
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
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: ScreenUtil().setSp(20)),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => BanUsers()),
                );
              },
              child: CircleAvatar(
                child: Icon(Icons.app_blocking_rounded,color: Colors.red,),
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: TabBarView(
          controller: AdminForums.tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            AdminPosts(category: 'status',),
            AdminPosts(category: 'gallery',),
            AdminPosts(category: 'grow',),
            AdminPosts(category: 'cooking',),
          ],
        ),
      ),
    );
  }
}
