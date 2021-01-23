import 'package:flutter/material.dart';
import '../constants.dart';

class CustomText extends StatelessWidget {

  final String text;
  final double size;
  final Color color;
  final TextAlign align;
  final bool isBold;
  final String font;
  final double height;
  final TextOverflow overflow;
  final int maxLines;
  const CustomText({Key key, this.text, this.size, this.color=Constants.kMainTextColor, this.align=TextAlign.center, this.isBold=true, this.font, this.height, this.overflow, this.maxLines}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle style = TextStyle(
        color: color,
        fontWeight: isBold?FontWeight.bold:FontWeight.normal,
        fontSize: size,
        height: height,
        letterSpacing: 0.6,
        fontFamily: 'Antonio'
    );


    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: align,
      style: style,
    );
  }
}