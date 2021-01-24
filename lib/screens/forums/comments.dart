import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'COMMENTS',
          color: Theme.of(context).accentColor,
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            children: [

              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(),
                      contentPadding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                      title: CustomText(text: 'Sanjula Hasaranga',align: TextAlign.start,),
                      subtitle: CustomText(text: 'Meka attac eka nisa puken hinaweyan bla vla vla vl vla vla vla vl alvla lbla balvl vla vlalbv bla blalb vlalbva vbl a',align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
                    )
                  ],
                ),
              ),



              ///comment box
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                  ),
                  SizedBox(width: ScreenUtil().setWidth(10),),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        fontFamily: 'Antonio',
                      ),
                      cursorColor: Theme.of(context).accentColor,
                      decoration: InputDecoration(
                        hintText: 'Type a comment...',
                        hintStyle: TextStyle(
                          fontFamily: 'Antonio',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send,color: Constants.kMainTextColor,),
                          onPressed: (){},
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
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
