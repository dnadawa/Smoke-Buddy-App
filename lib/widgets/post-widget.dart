import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:smoke_buddy/screens/forums/comments.dart';

import '../constants.dart';
import 'custom-text.dart';

class PostWidget extends StatefulWidget {

  final String name;
  final String date;
  final String description;
  final String proPic;
  final String image;

  const PostWidget({Key key, this.name, this.date, this.proPic, this.image, this.description}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          color: Constants.kFillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 3,color: Constants.kFillOutlineColor)
      ),
      child: Column(
        children: [

          ///propic and name
          ListTile(
            leading: CircleAvatar(),
            title: CustomText(text: widget.name,align: TextAlign.start,),
            subtitle: CustomText(text: widget.date,align: TextAlign.start,isBold: false,size: ScreenUtil().setSp(25),),
          ),

          ///text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: CustomText(
              text: widget.description,
              align: TextAlign.start,
              isBold: false,
            ),
          ),

          ///image
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Image.network(widget.image),
          ),

          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ///likes
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border),
                      SizedBox(width: ScreenUtil().setWidth(10),),
                      CustomText(text: '143 Likes',)
                    ],
                  ),
                ),

                ///comments
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Comments()),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.comment),
                        SizedBox(width: ScreenUtil().setWidth(10),),
                        CustomText(text: '23 Comments',)
                      ],
                    ),
                  ),
                ),

                ///follow
                Container(
                  child: Row(
                    children: [
                      Icon(Icons.notifications_none),
                      SizedBox(width: ScreenUtil().setWidth(10),),
                      CustomText(text: 'Follow',)
                    ],
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
