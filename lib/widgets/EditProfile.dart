import 'dart:convert';
import 'dart:developer';
import 'package:chatappwithfirebase/utils/regular_expressions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/City.dart';
import '../models/country.dart';
import '../models/state.dart';
import '../utils/utils.dart';

class EditProfile extends StatefulWidget {
   EditProfile({Key? key,required this.initialValues}) : super(key: key);

   final Map<String,String> initialValues;

  @override
  State<EditProfile> createState() => _EditProfileState();
}


class _EditProfileState extends State<EditProfile> {


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
   final emailFocus =FocusNode();
   final usernameFocus =FocusNode();
    final _fromKey = GlobalKey<FormState>();

   final firebase =FirebaseFirestore.instance.collection('users');

   final firebaseAuth =FirebaseAuth.instance;

  TextEditingController? txtEmail;
  TextEditingController? txtUsername;
  var updatedProfileImageLink;
  File? selectedImage;

  @override
  void initState() {
    txtEmail =TextEditingController(text: widget.initialValues['emailAddress']);
    txtUsername =TextEditingController(text: widget.initialValues['username']);
    if(widget.initialValues['country']!.isNotEmpty)
      {
        selectedCountry =widget.initialValues['country'] ;
      }
    if(widget.initialValues['state']!.isNotEmpty){

      selectedState =widget.initialValues['state'];
    }
    if(widget.initialValues['city']!.isNotEmpty){

      selectedCity=widget.initialValues['city'];
    }
    super.initState();

    values['country']!['id'] = widget.initialValues['country']!;
    values['state']!['id'] = widget.initialValues['state']!;
    values['city']!['id'] = widget.initialValues['city']!;
  }

  @override
  void didChangeDependencies() async{

    if(countryList.isEmpty){
      countryList = await getCountry();
      setState(() {
      });
    }

    if(stateList.isEmpty){
      stateList = await getState();
      if(widget.initialValues['state'] != null || widget.initialValues['state'] == ''){
        filterStateList = stateList.where((element) => element.countryId == widget.initialValues['country']).toList();

      }
      setState(() {});
    }

    if(cityList.isEmpty){
      cityList = await getCity();
      if(widget.initialValues['city'] != null || widget.initialValues['city'] == '') {
        filterCityList = cityList.where((element) => element.stateId ==
            widget.initialValues['state']).toList();
      }
      setState(() {});
    }



    super.didChangeDependencies();
  }



  Map<String,Map<String,String>> values ={
    'country': {'name': '','id': ''},
    'state': {'name': '','id': ''},
    'city': {'name': '','id': ''},
  };

   void getImage(ImageSource imageSource)async{
      ImagePicker picker =ImagePicker();
      Navigator.of(context).pop();
      var getImage= await picker.pickImage(source: imageSource,imageQuality: 50);
      selectedImage = await File(getImage!.path);
    }

   void updateProfile()async{
    emailFocus.unfocus();
    usernameFocus.unfocus();
    FocusScope.of(context).unfocus();
         if(
            widget.initialValues['imageUrl'] != updatedProfileImageLink && selectedImage != null ||
            widget.initialValues['emailAddress'] != txtEmail!.text ||
            widget.initialValues['username'] != txtUsername!.text ||
            widget.initialValues['country'] != values['country']!['id'] || widget.initialValues['city'] != values['city']!['id'] || widget.initialValues['state'] != values['state']!['id']
           )
          {
            _fromKey.currentState!.validate();

            if(_fromKey.currentState!.validate()) {
                   showDialog(
                       barrierDismissible: false,
                       context: context, builder: (context){
                     return Center(child: CircularProgressIndicator(),);
                   });
              if (widget.initialValues['imageUrl'] != updatedProfileImageLink &&
                  selectedImage != null) {
                 Navigator.of(context).pop();
                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context) {
                  return AlertDialog(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 5,),
                        Text('Uploading...')
                      ],
                    ),
                  );
                });
                final storage = FirebaseStorage.instance.ref().child(
                    'User_image').child(firebaseAuth.currentUser!.uid + '.jpg');
                await storage.putFile(selectedImage!);
                updatedProfileImageLink = await storage.getDownloadURL();
                await firebase.doc(firebaseAuth.currentUser!.uid).update({
                  'imageUrl': updatedProfileImageLink}).then((value) =>
                    Navigator.of(context).pop()).then((value) =>
                    setState(() {}));
              }
              if (widget.initialValues['emailAddress'] != txtEmail!.text) {
                final userdata = await firebase.doc(
                    firebaseAuth.currentUser!.uid).get();
                await firebaseAuth.signInWithEmailAndPassword(
                    email: userdata['email'], password: userdata['password']);
                await FirebaseAuth.instance.currentUser!.updateEmail(
                    txtEmail!.text);
                await firebase.doc(firebaseAuth.currentUser!.uid).update({
                  'email': txtEmail!.text}).then((value) => Navigator.of(context).pop()).then((value) =>
                    showDialog(
                       barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.done, color: Colors.white, size: 30,)),
                            content: Text('Email Address Updated'),
                            actions: [
                              CupertinoDialogAction(
                                  onPressed: () {
                                    widget.initialValues['emailAddress'] =
                                        txtEmail!.text;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Ok')
                              )
                            ],
                          );
                        }));
              }
              if (widget.initialValues['username'] != txtUsername!.text) {
                await firebase.doc(firebaseAuth.currentUser!.uid).update({
                  'username': txtUsername!.text}).then((value) => Navigator.of(context).pop()).then((value) =>
                    showDialog(
                      barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(
                                  Icons.done, color: Colors.white, size: 30,)),
                            content: Text('Username Updated'),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    widget.initialValues['username'] =
                                        txtUsername!.text;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ok')
                              ),
                            ],
                          );
                        })
                );
              } if( values['country']!['id'] != widget.initialValues['country'] ||
                       values['state']!['id'] != widget.initialValues['state'] ||
                       values['city']!['id'] != widget.initialValues['city']
                   ){

                    firebase.doc(firebaseAuth.currentUser!.uid).update({
                      'country': values['country'],
                      'state': values['state'],
                      'city': values['city'],
                    }).then((value) => Navigator.of(context).pop()).then((value) =>
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.done, color: Colors.white, size: 30,)),
                                content: Text('Location Updated'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        widget.initialValues['country'] = values['country']!['id']!;
                                        widget.initialValues['state'] = values['state']!['id']!;
                                        widget.initialValues['city'] = values['city']!['id']!;
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('ok')
                                  ),
                                ],
                              );
                            }));
                   }
            }
         }
    else{
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Alert'),
            content: const Text('Changes Not Found'),
          ),
        );
    }
   }

   void _showImagePickOptions(context){
     showModalBottomSheet(
         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft :Radius.circular(20),topRight:Radius.circular(20) )),
         context: context,
         builder: (context){
           return Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children:  [
                 ListTile(
                   onTap:() => getImage(ImageSource.camera),
                   leading: const Icon(Icons.camera_enhance,color: Colors.pink,),
                   title: const Text('Capture Image',style: TextStyle(color: Colors.grey),),
                 ),
                 ListTile(
                     onTap:() => getImage(ImageSource.gallery),
                     leading: const Icon(Icons.image_sharp,color: Colors.purple,),
                     title: const Text('Select Image',style: TextStyle(color: Colors.grey),)
                 )
               ],
             ),
           );
         });
       }

  List<Country> countryList =[];
  List<City> cityList=[];
  List<CountryState> stateList=[];
  List<CountryState> filterStateList =[];
  List<City> filterCityList =[];
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Edit Profile',style: TextStyle(color: Colors.black),),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        },icon: Icon(CupertinoIcons.back,color: iconColor,),),
        actions: [
          const Icon(Icons.more_vert,color: Colors.black,)
        ],
      ),
      body: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:updatedProfileImageLink == null ? NetworkImage(widget.initialValues['imageUrl']!) :
                              NetworkImage(updatedProfileImageLink)
                            ),
                            CircleAvatar(
                              backgroundColor: accentColor,
                              child: IconButton(onPressed:()=> _showImagePickOptions(context),icon: Icon(Icons.camera_enhance,color: Colors.white,
                                ),
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(height:  MediaQuery.of(context).size.height * 0.04,),
                     Form(
                         key: _fromKey,
                         child: Column(
                          children: [
                              TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                focusNode: emailFocus,
                                inputFormatters:[ FilteringTextInputFormatter.allow(RegExp(emailEditingExpression))],
                                validator: (val){
                                  if(emailFocus.hasFocus){
                                    return null;
                                  }
                                  if(val!.isEmpty){

                                    return 'enter email address';
                                  }
                                  if(!val.contains('@') || !val.contains('.') || !RegExp(emailExpressions).hasMatch(val))
                                  {
                                    return 'enter valid email address';
                                  }
                                     return null;
                                },
                                textInputAction: TextInputAction.next,
                                controller: txtEmail,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  label: Text('Email Address'),
                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentColor)),
                                 enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: iconColor))
                                ),
                              ),
                         SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                         TextFormField(
                           focusNode: usernameFocus,
                           textInputAction: TextInputAction.next,
                           validator: (val){
                             if(val!.isEmpty){
                               return 'Empty Username';
                             }
                             if(val.length < 5){
                               return 'Username must 5 characters need';
                             }
                             return null;
                           },
                           inputFormatters: [
                             FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                           ],
                                controller: txtUsername,
                                decoration: InputDecoration(
                                labelStyle: TextStyle(fontFamily: 'Roboto'),
                                prefixIcon: Icon(Icons.supervised_user_circle_rounded,color: accentColor,),
                                label: Text('Username'),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: accentColor)),
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: iconColor))
                            ),
                         ),

                        ],
                     )),
                    SizedBox(height: 5,),
                    Container(
                      height: 60,
                      child: DropdownButton(
                          menuMaxHeight: 200,
                          isExpanded: true,
                          hint: Text('select Country'),
                          value: selectedCountry,
                          items: countryList.map((e) => DropdownMenuItem(child: Text(e.name),value: e.countryId,)).toList(), onChanged: (val){
                            filterStateList =[];
                            filterCityList =[];
                            selectedCity = null;
                            selectedState = null;
                            filterStateList = stateList.where((element) => element.countryId == val).toList();
                            setState(() {
                              selectedCountry =val;
                            });
                            Country selectedCountryName = countryList.firstWhere((element) => element.countryId == val);
                            values['state']!['name'] = '';
                            values['state']!['id'] = '';
                            values['city']!['name'] = '';
                            values['city']!['id'] ='';
                            values['country']!['name'] = selectedCountryName.name;
                            values['country']!['id'] = selectedCountryName.countryId;
                            print(values);
                      }),
                      ),
                    Container(
                      height: 60,
                      child: DropdownButton(
                        hint: Text('Select State',style: filterStateList.isEmpty ? TextStyle(color: CupertinoColors.systemGrey4) : null,),
                          menuMaxHeight: 200,
                          isExpanded: true,
                          value: selectedState,
                          items: filterStateList.map((e) => DropdownMenuItem(child: Text(e.name),value: e.id,)).toList(), onChanged: (val){
                            values['city']!['name'] = '';
                            values['city']!['id'] ='';
                            selectedState = val;
                            filterCityList =[];
                            selectedCity = null;
                            filterCityList = cityList.where((element) => element.stateId == val).toList();

                            if(filterCityList.length ==0){

                              values['city']!['name'] = '';
                              values['city']!['id'] ='';

                            }

                            setState(() {

                            });
                            Country selectedCountry = countryList.firstWhere((element) => element.countryId == values['country']!['id']);

                            values['country']!['name'] = selectedCountry.name;
                            values['country']!['id'] = selectedCountry.countryId;


                            var selectedStateName = filterStateList.firstWhere((element) => element.id == val);
                            values['state']!['name'] = selectedStateName.name;
                            values['state']!['id'] = selectedStateName.id;
                            print(values);

                      }),
                      ),
                    Container(
                      height: 60,
                      child: DropdownButton(
                        hint: Text('select city here',style: filterCityList.isEmpty ? TextStyle(color: CupertinoColors.systemGrey4): null,),
                                    menuMaxHeight: 200,
                                    isExpanded: true,
                                    value: selectedCity,
                                    items: filterCityList.map((e) => DropdownMenuItem(child: Text(e.name),value: e.id,)).toList(),
                                    onChanged: (val){
                                      selectedCity = val;
                                      City selectedCountryName = filterCityList.firstWhere((element) => element.id == val);
                                      values['city']!['name'] = selectedCountryName.name;
                                      values['city']!['id'] = selectedCountryName.id;
                                      setState(() {

                                      });
                                      print(values);
                                    }
                      )
                    )
                    ,SizedBox(height:  MediaQuery.of(context).size.height * 0.03,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          fixedSize: Size(200, 50)),
                          onPressed: updateProfile,
                      child: Text('Update Profile'),),
                  ],
                ),
              ),
            ),
    );
  }
}
