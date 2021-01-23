import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import '../constants.dart';
import 'custom-text.dart';

class TabButton extends StatelessWidget {

  final String name;
  final String image;
  final bool selected;

  const TabButton({Key key, this.name, this.image, this.selected = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Constants.kMainTextColor,width: selected?2:1),
            color: Theme.of(context).accentColor
        ),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: ScreenUtil().setHeight(40),
                  child: Image.asset('assets/images/$image')
              ),
              SizedBox(width: ScreenUtil().setWidth(10),),
              CustomText(text: name,isBold: false,),
              SizedBox(width: ScreenUtil().setWidth(10),),
            ],
          ),
        ),
      ),
    );
  }
}
