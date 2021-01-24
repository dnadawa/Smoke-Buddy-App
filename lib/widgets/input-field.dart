import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

class InputField extends StatelessWidget {

  final String hint;
  final TextInputType type;
  final bool isPassword;
  final TextEditingController controller;
  final Widget suffix;
  final Widget prefix;
  final bool isLabel;

  const InputField({Key key, this.hint, this.type, this.isPassword=false, this.controller, this.suffix, this.prefix, this.isLabel=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type,
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(
        fontFamily: 'Antonio',
      ),
      cursorColor: Theme.of(context).accentColor,
      decoration: InputDecoration(
        suffix: suffix,
        prefix: prefix,
        hintText: hint,
        labelText: isLabel?hint:null,
        labelStyle: TextStyle(
          fontFamily: 'Antonio',
        ),
        hintStyle: TextStyle(
          fontFamily: 'Antonio',
        ),
        filled: true,
        fillColor: Constants.kFillColor,
        contentPadding: EdgeInsets.all(ScreenUtil().setWidth(35)),
        enabledBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Constants.kFillOutlineColor, width: 2),
        ),
        focusedBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Constants.kFillOutlineColor, width: 2),
        ),
      ),
    );
  }
}