import 'dart:convert';

import 'package:chatappwithfirebase/Screens/authScreen.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/City.dart';
import '../models/country.dart';
import '../models/state.dart';


class BottomNavigation extends StatefulWidget {

   BottomNavigation({
     required this.firstItem,
     required this.secondItem,
     required this.thirdItem,
     required this.fourthItem,
});

    final VoidCallback firstItem;
    final VoidCallback secondItem;
    final VoidCallback thirdItem;
    final VoidCallback fourthItem;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

    bool firstItemColor = true;
    bool secondItemColor = false;
    bool thirdItemColor = false;
    bool fourthItemColor = false;

    @override
  void initState() {
      getCountry();
      getState();
      getCity();
      super.initState();
  }
    List<City> cityList =[];
    List<Country> countryList=[];
    List<CountryState> stateLIst =[];

    void getCountry()async{
      final response = rootBundle.loadString('locationdata/countries.json');
      var data =  json.decode(await response) as List;
      countryList = data.map<Country>((e) => Country(name: e['name'], countryId: e['id'].toString())).toList();
    }

    void getCity()async{
      final response =await rootBundle.loadString('locationdata/cities.json');
      var data = json.decode(response) as List;
      cityList =data.map<City>((e) => City(name: e['name'], stateId: e['state_id'],id: e['id'])).toList();
    }

    void getState()async{
      final response = await rootBundle.loadString('locationdata/states.json');
      var data =json.decode(response) as List;
      stateLIst =data.map<CountryState>((e) => CountryState(name: e['name'], id: e['id'], countryId: e['country_id'])).toList();
    }

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        children:[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(55),topLeft: Radius.circular(55))
            ),
            padding: EdgeInsets.only(top : 20,bottom : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: ()async{
                    setState(() {
                      firstItemColor =true;
                      secondItemColor =false;
                      thirdItemColor =false;
                      fourthItemColor=false;
                      widget.firstItem();
                    });
                  },
                  icon: Icon(
                    Icons.home,
                    color: firstItemColor ? accentColor: iconColor,
                    size: 35 ,)
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: (){
                    setState(() {
                        firstItemColor =false;
                        secondItemColor =true;
                        thirdItemColor =false;
                        fourthItemColor=false;
                        widget.secondItem();
                    });
                  },
                  icon: Icon(
                    Icons.chat_outlined,
                    color: secondItemColor ? accentColor: iconColor,
                    size: 35,)
                ),
                SizedBox(width: 10,),
                IconButton(
                  enableFeedback: false,
                  onPressed: (){
                    setState(() {
                      firstItemColor =false;
                      secondItemColor =false;
                      thirdItemColor =true;
                      fourthItemColor=false;
                      widget.thirdItem();
                    });
                  },
                  icon: Icon(
                    Icons.call,
                    color: thirdItemColor ? accentColor: iconColor,
                    size: 35,
                  ),
                ),
                IconButton(
                  enableFeedback: false,
                  onPressed: (){
                    setState(() {
                      firstItemColor =false;
                      secondItemColor =false;
                      thirdItemColor =false;
                      fourthItemColor=true;
                      widget.fourthItem();
                    });
                  },
                  icon:  Icon(
                    CupertinoIcons.profile_circled,
                    color: fourthItemColor ? accentColor : iconColor,
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: -16,
              left: 165,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: accentColor,blurRadius: 2)]
                ),
                child: CircleAvatar(
                  backgroundColor: accentColor,radius: 30,
                  child: InkWell(
                      onTap: (){
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen(onlyAddUser: true,)));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return AuthScreen(onlyAddUser: false,);
                        }));

                      },
                      child: Icon(Icons.add,color: Colors.white,size: 40,)),
                ),
              ))
        ]
    );
  }
}
