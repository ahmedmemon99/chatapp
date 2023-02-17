import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/City.dart';
import '../models/country.dart';
import '../models/state.dart';


class DropDownWidget extends StatefulWidget {
   DropDownWidget({
     required this.passData,
    Key? key,
  }) : super(key: key);


  void Function(Map<String,Map<String,String>> values) passData;
  List<Country> countryList =[];
  List<City> cityList=[];
  List<CountryState> stateList=[];

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {

  List<CountryState> filterStateList =[];
  List<City> filterCityList =[];
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  Map<String,Map<String,String>> values ={
    'country': {'name': '','id': ''},
    'state': {'name': '','id': ''},
    'city': {'name': '','id': ''},
  };

  Future<List<Country>> getCountry()async{
    final response =await rootBundle.loadString('locationdata/countries.json');
    var data =json.decode(response)  as List;
    return data.map<Country>((e) => Country(name: e['name'], countryId: e['id'].toString())).toList();
  }

  Future<List<City>> getCity()async{
    final response =await rootBundle.loadString('locationdata/cities.json');
    var data = json.decode(response) as List;
    return data.map<City>((e) => City(name: e['name'], stateId: e['state_id'],id: e['id'])).toList();
  }

  Future<List<CountryState>> getState()async{
    final response = await rootBundle.loadString('locationdata/states.json');
    var data =json.decode(response) as List;
   return data.map<CountryState>((e) => CountryState(name: e['name'], id: e['id'], countryId: e['country_id'])).toList();
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2,),
          ButtonTheme(
            child:FutureBuilder(
                future: getCountry(),
                builder: (context,snap){
                  if(!snap.hasData || snap.connectionState == ConnectionState.waiting){
                    return DropdownButton(
                      value: selectedCountry,
                      isExpanded: true,
                      hint: Text('Select your Country',style: widget.countryList.isEmpty? TextStyle(color: CupertinoColors.systemGrey3) : null,),
                      menuMaxHeight: 200,
                      items: [],
                      onChanged: (val){
                      },
                    );
                  }
                  getState().then((value) => widget.stateList = value);
                  getCity().then((value) => widget.cityList =value);
                  return DropdownButton(
                    value: selectedCountry,
                    isExpanded: true,
                    hint: Text('Select your Country'),
                    menuMaxHeight: 200,
                    items: snap.data!.map((e) => DropdownMenuItem(
                        alignment: Alignment.centerLeft,
                        child: Text(e.name),
                        value: e.countryId)
                    ).toList(),
                    onTap: (){
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (val){
                      selectedState = null;
                      selectedCity= null;
                      filterCityList= [] ;
                      filterStateList = widget.stateList.where((element) => element.countryId == val).toList();
                      setState((){
                        selectedCountry =val;
                     });
                      var country = snap.data!.singleWhere((element) => element.countryId == val);
                      values['country']!['name'] =country.name;
                      values['country']!['id'] =country.countryId;
                      widget.passData(values);
                    },
                  );
                }),
          ),
          DropdownButton(
            value: selectedState,
              isExpanded: true,
              hint: Text('Select state',style: filterStateList.isEmpty ? TextStyle(color: CupertinoColors.systemGrey3) : null,),
              menuMaxHeight: 200,
              items: filterStateList.map((e) {
                return DropdownMenuItem(
                alignment: Alignment.centerLeft,
                child: Text(e.name),value: e.id,);
              }).toList(),
              onChanged: (val){
                selectedCity= null;
                filterCityList =[];
                  filterCityList =
                      widget.cityList.where((element) => element.stateId == val)
                          .toList();
                  setState(() {
                      selectedState =val;
                  });
                var state = widget.stateList.singleWhere((element) => element.id == val);
                values['state']!['name'] =state.name;
                values['state']!['id'] =state.id;
                widget.passData(values);
              }
          ),
          StatefulBuilder(
            builder: (context,state){
              return DropdownButton(
                  hint:  Text('Selected City',
                    style:filterCityList.isEmpty ? TextStyle(color: CupertinoColors.systemGrey3) : null,),
                  value: selectedCity,
                  menuMaxHeight: 200,isExpanded: true,
                  items: filterCityList.map((e) => DropdownMenuItem(
                      alignment: Alignment.centerLeft,
                      child: Text(e.name),value: e.id)).toList(),
                  onChanged: (val){
                    state((){
                      selectedCity = val;
                    });
                    var city = widget.cityList.singleWhere((element) => element.id == val);
                    values['city']!['name'] =city.name;
                    values['city']!['id'] = city.id;
                    widget.passData(values);
                    print("drop widget $values");
                  }
              );
            },
          ),
        ],
      ),
    );
  }
}
