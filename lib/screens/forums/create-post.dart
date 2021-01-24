import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/widgets/button.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'CREATE POST',
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Constants.kFillColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Constants.kFillOutlineColor,width: 2)
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [
                          ///profile
                          Expanded(
                            child: ListTile(
                              leading: CircleAvatar(),
                              title: CustomText(text: 'Ali Sabri',align: TextAlign.start,),
                            ),
                          ),

                          ///picker
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
                            child: SizedBox(
                                height: ScreenUtil().setHeight(60),
                                child: Image.asset('assets/images/picker.png')
                            ),
                          )
                        ],
                      ),


                      ///textfield
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        child: TextField(
                          style: Constants.kLoginTextStyle,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "What's on your mind...",
                            hintStyle: Constants.kLoginTextStyle,
                            border: InputBorder.none,
                          ),
                        ),
                      ),


                      ///image
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        child: Image.network('https://i.pinimg.com/736x/ee/5a/01/ee5a0191372af6acd13d08ba7fb3417c.jpg'),
                      ),
                    ],
                  ),
                ),


                ///button
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(100),
                  child: Button(
                    text: 'POST',
                    onPressed: (){},
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
