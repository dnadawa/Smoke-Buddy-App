import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {
  final String text;
  final double borderRadius;
  final Function onPressed;
  final double fontSize;

  const Button({Key key, this.text, this.borderRadius=40, this.onPressed, this.fontSize=40}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: Color(0xff3c4a22),width: 2)
      ),
      child: CustomText(text: text,size: ScreenUtil().setHeight(fontSize),),
    );
  }
}
