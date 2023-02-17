import 'package:chatappwithfirebase/Screens/callscreen.dart';
import 'package:chatappwithfirebase/Screens/profilescreen.dart';
import 'package:chatappwithfirebase/Screens/usersscreen.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../widgets/bottomnavigatonbar.dart';
import 'Homescreen.dart';


class MainScreen extends StatefulWidget {
   MainScreen({Key? key,required this.index}) : super(key: key);

     final int index;


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget> screens =[
    HomeScreen(),
    UsersScreen(),
    CallScreen(),
    ProfileScreen(
    ),
  ];

    @override
  void initState() {
   index =widget.index;
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: index == 3 ? AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Profile',style: TextStyle(color: Colors.black),),
        actions: [
          Icon(Icons.more_vert,color: Colors.black,)
        ],) : null,
      backgroundColor:backgroundColor,
      body:screens[index],
      bottomNavigationBar: BottomNavigation(
          firstItem:() => setState(() { index = 0;  }),
          secondItem:() => setState(() { index = 1;  }),
          thirdItem:()=> setState(() { index = 2;  }),
          fourthItem:()=> setState(() { index = 3;  }),
      ),
    );
  }
}
