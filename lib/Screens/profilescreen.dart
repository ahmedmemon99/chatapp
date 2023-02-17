import 'package:chatappwithfirebase/widgets/Profilewidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../models/country.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    @override
  void initState(){
    print('init called');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebase =FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    return StreamBuilder(
        stream: firebase,
        builder: (context,user){
          if(!user.hasData){
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              ProfileWidget(
                country: user.data!['country']['id'],
                state: user.data!['state']['id'],
                city: user.data!['city']['id'],
                username: user.data!['username'],
                imageUrl: user.data!['imageUrl'],
                email: user.data!['email'],
              ),
            ],
          );
        },
    );
  }
}
