import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smoke_buddy/widgets/custom-text.dart';

import '../../constants.dart';

class Policies extends StatelessWidget {
  final String title;

  const Policies({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: CustomText(text: title,color: Theme.of(context).accentColor,),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)
        ),
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: Constants.appGradient),
      ),
    );
  }
}
