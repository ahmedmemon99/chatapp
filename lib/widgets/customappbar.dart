

import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/member_profilewidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomAppBar extends StatelessWidget {
  const   CustomAppBar({
    Key? key,
    required this.username,
    required this.profileImageUrl,
    required this.deviceSize,
    required this.emailAddress,
    required this.country,
    required this.state,
    required this.city
  }) : super(key: key);

  final Size deviceSize;
  final String username;
  final String profileImageUrl;
  final String emailAddress;
  final String country;
  final String state;
  final String city;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showDialog(context: context, builder: (context){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Padding(
                padding: const EdgeInsets.only(left: 20,right:20,top:50,bottom:20),
                child: MemberProfileWidget(
                  city: city,
                  state: state,
                  country: country,
                  username: username,
                  emailAddress: emailAddress,

                ),
              ),
              Positioned(
                top: -40,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 45,
                ),
              )
              ]
            ),
          );
        });
      },
      child: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),
                onPressed: (){
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0,),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                backgroundColor: accentColor,radius: 22,),
            ),
            SizedBox(width: deviceSize.width * 0.04,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: deviceSize.height *0.02,),
                  Text(username,style: TextStyle(color: Colors.black,overflow: TextOverflow.fade,),
                    maxLines: 1,softWrap: false,),
                  Text('online',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w300,fontSize: 18),)
                ],),),],
          ),
        actions: [
          IconButton(
              icon: Icon(Icons.videocam_outlined,size: 30,color: iconColor,),
              onPressed: (){},
          ),
          IconButton(
              icon: Icon(Icons.call,size: 25,color: iconColor,),
              onPressed: (){},
          ) ],
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(bottomRight:Radius.circular(35),bottomLeft: Radius.circular(35)),
            borderSide: BorderSide.none
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}