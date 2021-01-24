import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {
  final String text;
  final double borderRadius;
  final Function onPressed;
  final double fontSize;
  final bool leadingImage;
  final String image;

  const Button({Key key, this.text, this.borderRadius=40, this.onPressed, this.fontSize=40, this.leadingImage=false, this.image}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    Widget textChild = CustomText(
      text: text,
      size: ScreenUtil().setHeight(fontSize)
    );

    Widget imageChild = Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setHeight(20),
          ScreenUtil().setHeight(20),
          ScreenUtil().setHeight(40),
          ScreenUtil().setHeight(20)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: ScreenUtil().setHeight(70),
              child: Image.asset('assets/images/$image')
          ),
          SizedBox(width: ScreenUtil().setWidth(20),),
          CustomText(text: text,size: ScreenUtil().setHeight(fontSize),),
        ],
      ),
    );


    return RaisedButton(
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
      elevation: 0,
      padding: leadingImage?EdgeInsets.zero:null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: Color(0xff3c4a22),width: 2)
      ),
      child: leadingImage?imageChild:textChild,
    );
  }
}
