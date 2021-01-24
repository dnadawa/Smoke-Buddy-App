import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/bottom-sheet.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';
import 'package:smoke_buddy/widgets/input-field.dart';

import '../../constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'EDIT PROFILE',color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
        child: Padding(
          padding:  EdgeInsets.only(top: ScreenUtil().setHeight(100)),
          child: Stack(
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(40),ScreenUtil().setHeight(80),ScreenUtil().setHeight(40),0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Constants.kFillColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Constants.kFillOutlineColor,width: 3)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(100),
                      ),
                      
                      ///name
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: InputField(
                          hint: 'SmokeBuddy Name',
                          isLabel: true,
                        ),
                      ),
                      
                      
                      ///status
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: InputField(
                          hint: 'SmokeBuddy Status',
                          isLabel: true,
                        ),
                      ),
                      
                      
                      ///button
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                        child: SizedBox(
                          width: ScreenUtil().setWidth(400),
                          height: ScreenUtil().setHeight(100),
                          child: Button(
                            text: 'SAVE',
                            onPressed: (){},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              ///pro pic
              Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                    radius: ScreenUtil().setHeight(80),
                  )
              )
            ],
          ),
        ),
      ),


      bottomSheet: AppBottomSheet(),
    );
  }
}
