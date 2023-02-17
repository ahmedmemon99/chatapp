
import 'dart:convert';

import 'package:chatappwithfirebase/Screens/mainscreen.dart';
import 'package:chatappwithfirebase/Screens/splashscreen.dart';
import 'package:chatappwithfirebase/models/state.dart';
import 'package:chatappwithfirebase/models/City.dart';
import 'package:chatappwithfirebase/models/country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
void main()async{

   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    runApp(ChatApp());
}

class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {

  List<City> cityList =[];
  List<Country> countryList =[];
  List<CountryState> stateList =[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,streamData){
          if(streamData.hasData){
             return MainScreen(index: 0);
          }
          else{
            return SplashScreen();
          }
        },
      )
    );
  }
}
