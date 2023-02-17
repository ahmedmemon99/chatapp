import 'package:chatappwithfirebase/Screens/authScreen.dart';
import 'package:chatappwithfirebase/api/customtranscation.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/EditProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.email,
    required this.country,
    required this.state,
    required this.city
  }) : super(key: key);

  final String username;
  final String imageUrl;
  final String email;
  final String country;
  final String state;
  final String city;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20,bottom: 20,left: 40,right: 30),
          child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          height : 100,
                          width :100,
                          decoration: BoxDecoration(
                        ),
                          child: ClipOval(
                            child: Image.network(imageUrl,fit: BoxFit.fill,loadingBuilder: (context,child,loading){
                              if(loading == null){
                                return child;
                              }
                              return Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  color: accentColor,),
                              );
                            },),
                          ),
                        ),
                      SizedBox(width: 30,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: TextStyle(fontSize: 25,),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 5,),
                            Text(email,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(color: iconColor,),),
                          ],

                        ),
                      ),
                      IconButton(onPressed: (){
                        Navigator.of(context).push(CustomRouteTransaction(builder: (context){
                          return EditProfile(
                            initialValues: {
                              'username' :username,
                              'emailAddress' : email,
                              'imageUrl': imageUrl,
                              'country': country,
                              'state': state,
                              'city': city
                            },);
                        }));
                        print('$country $state,$city');
                      }, icon: Icon(Icons.edit,color: accentColor,))
                    ],
                  ),
                ],
              ),
        ),
        TextButton(
          onPressed: ()async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return AuthScreen(onlyAddUser: true,);}));
          },
          child: Text('Log Out',style: TextStyle(fontWeight: FontWeight.w500),),
          style: ButtonStyle().copyWith(
              padding: MaterialStatePropertyAll(EdgeInsets.only(left: 30)),
              textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              foregroundColor: MaterialStatePropertyAll(Colors.red)
          ),
        ),
      ],
    );
  }
}
