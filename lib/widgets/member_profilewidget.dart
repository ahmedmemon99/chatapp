import 'package:flutter/material.dart';

class MemberProfileWidget extends StatelessWidget {
  const MemberProfileWidget({Key? key,required this.username,required this.emailAddress,required this.country,required this.state,required this.city}) : super(key: key);

  final String username;
  final String emailAddress;
  final String country;
  final String state;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: Row(
                children: [
                  Text('Username',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10,),
                  Text(username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                  ]
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: Row(
                children: [
                  Text('email Address',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10,),
                  Expanded(child: FittedBox(child: Text(emailAddress,overflow: TextOverflow.fade,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)))),
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: Row(
                children: [
                  Text('country',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10,),
                  Text(country,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: Row(
                children: [
                  Text('state',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10,),
                  Text(state,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            child: Row(
                children: [
                  Text('city',style: TextStyle(color: Colors.grey),),
                  SizedBox(width: 10,),
                  Text(city,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
