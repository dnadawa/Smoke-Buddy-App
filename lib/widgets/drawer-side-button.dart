import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/constants.dart';

import 'custom-text.dart';

class DrawerSideButton extends StatelessWidget {

  final String image;
  final String name;
  final bool activate;
  final Function onTap;

  const DrawerSideButton({Key key, this.image, this.name, this.activate=false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtil().setWidth(170),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ///indicator
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: ScreenUtil().setWidth(10),
                color: activate?Constants.kYellow:Colors.transparent,
                height: ScreenUtil().setHeight(135),
              ),
            ),

            Expanded(child: Container()),

            Column(
              children: [
                ///image
                SizedBox(
                    height: ScreenUtil().setHeight(100),
                    child: Image.asset('assets/images/$image')
                ),
                SizedBox(height: ScreenUtil().setHeight(5),),

                ///name
                CustomText(text: name,size: ScreenUtil().setSp(25),)
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
