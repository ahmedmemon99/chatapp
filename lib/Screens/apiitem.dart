import 'package:chatappwithfirebase/Screens/apidataviewscreen.dart';
import 'package:chatappwithfirebase/api/apiModel.dart';
import 'package:chatappwithfirebase/api/customtranscation.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/material.dart';


class ApiItem extends StatelessWidget {

  const ApiItem({Key? key,required this.postId,required this.title,required this.body}) : super(key: key);
  final String title;
  final String body;
  final int postId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        color: accentColor,
        margin: EdgeInsets.all(10),
        child: ListTile(
          isThreeLine: true,
          contentPadding: EdgeInsets.all(20),
          onTap: (){
            Navigator.of(context).push(CustomRouteTransaction(builder: (context){
              return ApiDataViewScreen(postId:postId);
              },
            ));
          },
          leading: CircleAvatar(child: Text(postId.toString(),style: TextStyle(color: accentColor),),backgroundColor: Colors.white,),
          title:  Text(title,style: TextStyle(color: Colors.white,fontSize: 26),),
          subtitle: Text(body,style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
