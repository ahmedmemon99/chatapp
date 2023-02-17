import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/material.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({Key? key,required this.title,required this.body}) : super(key: key);

  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        color: accentColor ,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Text(title,
                style: TextStyle(color: Colors.white,fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(body,
                style: TextStyle(color: Colors.yellow),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
