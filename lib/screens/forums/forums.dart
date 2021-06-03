import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/drawer.dart';
import 'package:smoke_buddy/screens/forums/posts.dart';
import 'package:smoke_buddy/screens/home.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/tab-button.dart';

import '../../constants.dart';

class Forums extends StatefulWidget {

  static TabController tabController;
  final int index;

  const Forums({Key key, this.index}) : super(key: key);

  @override
  _ForumsState createState() => _ForumsState();
}

class _ForumsState extends State<Forums>  with SingleTickerProviderStateMixin{

  bool t1;
  bool t2;
  bool t3;
  bool t4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Forums.tabController = TabController(length: 4, vsync: this, initialIndex: widget.index);
    Forums.tabController.addListener(() {
      print('index is: '+Forums.tabController.index.toString());
      setState(() {
        switch(Forums.tabController.index){
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) =>
                Home()), (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: ScreenUtil().setWidth(430),
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
            controller: Forums.tabController,
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
        ),
        drawer: Drawer(
          child: MenuDrawer(controller: Forums.tabController,screen: 'forums',),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: Constants.appGradient),
          child: TabBarView(
            controller: Forums.tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Posts(category: 'status',),
              Posts(category: 'gallery',),
              Posts(category: 'grow',),
              Posts(category: 'cooking',),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomSheet(),
      ),
    );
  }
}
