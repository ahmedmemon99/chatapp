import 'dart:developer';
import 'dart:io';
import 'package:chatappwithfirebase/Screens/mainscreen.dart';
import 'package:chatappwithfirebase/api/customtranscation.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/newAuthForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthScreen extends StatefulWidget {
   AuthScreen({
     Key? key,this.onlyAddUser =true,

   }) : super(key: key);

    bool onlyAddUser;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  void _submitform
      (String email,String username,String password,
              bool isLogged,BuildContext context,bool isLoading,
                      [File? image,Map<String,Map<String,String>>? locationdata])async{
   try {
     final auth = FirebaseAuth.instance;
    if (isLogged) {
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) async{
        var user = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: email).get();
        List listOfTokens = user.docs.first['toToken'] ?? [];
        if(!listOfTokens.contains(await FirebaseMessaging.instance.getToken()) || listOfTokens.isEmpty){
          listOfTokens.add(await FirebaseMessaging.instance.getToken());
        }
        FirebaseFirestore.instance.collection('users').doc(user.docs.first.id).update(
            {
               'toToken' : listOfTokens
            });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
            MainScreen(index: 0,)
        ));

      });
    }
    else {
      if(FirebaseAuth.instance.currentUser == null){
        UserCredential authData= await auth.createUserWithEmailAndPassword( email: email, password: password);
        final fbstorage = FirebaseStorage.instance.ref().child('User_image').child('${authData.user!.uid}.jpg');
        await fbstorage.putFile(image!);
        final url = await fbstorage.getDownloadURL();
        final firebase= FirebaseFirestore.instance.collection('users');
        await firebase.doc(authData.user!.uid).set(
        {
          'username' : username,
          'email' : email,
          'password': password,
          'imageUrl' : url,
          'userId' :authData.user!.uid,
          'country': {'name': locationdata!['country']!['name'],'id':locationdata['country']!['id']} ,
          'state' : {'name': locationdata['state']!['name'], 'id':locationdata['state']!['id']} ,
          'city': {'name': locationdata['city']!['name'], 'id':locationdata['city']!['id']},
          'toToken' : [await FirebaseMessaging.instance.getToken()]
        },).then((value) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context){
            return MainScreen(index: 0,);
          }));
        });
      }
      else{
        var oldEmail;
        var oldPassword;
        oldEmail =await FirebaseAuth.instance.currentUser!.email;
        final oldPasswordGet =await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
        oldPassword =await oldPasswordGet.data()!['password'];
        UserCredential authData= await auth.createUserWithEmailAndPassword( email: email, password: password).whenComplete(() async{
           print('$oldPassword $oldEmail' );
             await FirebaseAuth.instance.signOut();
             await FirebaseAuth.instance.signInWithEmailAndPassword(email: oldEmail, password: oldPassword);
        });
        final fbstorage = FirebaseStorage.instance.ref().child('User_image').child('${authData.user!.uid}.jpg');
        await fbstorage.putFile(image!);
        final url = await fbstorage.getDownloadURL();
        final firebase= FirebaseFirestore.instance.collection('users');
        await firebase.doc(authData.user!.uid).set({
          'username' : username,
          'email' : email,
          'password': password,
          'imageUrl' : url,
          'userId' :authData.user!.uid,
          'country': {'name': locationdata!['country']!['name'],'id':locationdata['country']!['id']} ,
          'state' : {'name': locationdata['state']!['name'], 'id':locationdata['state']!['id']},
          'city': {'name': locationdata['city']!['name'], 'id':locationdata['city']!['id']},
        }).then((value) {
          Fluttertoast.showToast(msg: 'User added successfully').then((value) =>  Navigator.of(context).pushReplacement(
            CustomRouteTransaction(builder: (context) => MainScreen(index: 1,))
          ),);
        });
      }
    }
      }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text(e.toString())));
                setState(() {
                   isLoading =false;
                });
        }
  }

  bool isLoginMode =true;
  GlobalKey<FormFieldState> _emailKey =GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _passwordKey =GlobalKey<FormFieldState>();
  GlobalKey<FormFieldState> _usernameKey =GlobalKey<FormFieldState>();

  bool emailValid= true;
  bool passwordValid= true;
  bool usernameValid= true;
  bool validData = true;

  @override
  Widget build(BuildContext context) {
    log('auth Screen Build method callled');
     return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:PreferredSize(
        preferredSize: Size(double.infinity,40),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.white

          ),
          backgroundColor: Colors.transparent,

          leading:  !widget.onlyAddUser ? IconButton(onPressed: (){

            Navigator.of(context).pop();

          },icon: Icon(CupertinoIcons.arrow_left),): Container(),
          elevation: 0,
          actions: [
            widget.onlyAddUser ? GestureDetector(
              onTap: (){
                setState(() {
                  isLoginMode =!isLoginMode;
                  if(_emailKey.currentState != null) {
                   _emailKey.currentState!.reset();
                   }
                  if(_passwordKey.currentState != null) {
                    _passwordKey.currentState!.reset();
                  }
                  if(_usernameKey.currentState != null) {
                    _usernameKey.currentState!.reset();
                  }
                  emailValid= true;
                  passwordValid= true;
                  usernameValid= true;
                  validData = true;
                });

              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                padding: EdgeInsets.only(top: 8,left: 15,right: 15),
                margin: EdgeInsets.only(left: 20,right:10,top: 6),
                child: isLoginMode ? Text('New User') : Text('Sign in'),
              )
            )  : Container(),
          ],
        ),
      ),
       body:Container(
            decoration: BoxDecoration(
            color: Colors.black,
            gradient: LinearGradient(
              colors: [
                authFromBackgroundFirColor,
                authFromBackgroundSecColor
              ],
              begin: Alignment.bottomLeft,
              end:  Alignment.topRight,
            )
          ),
          child: SafeArea(
              child: NewAuthForm(
                emailKey: _emailKey,
                usernameKey: _usernameKey,
                passwordKey: _passwordKey,
                emailValid: emailValid,
                passwordValid: passwordValid,
                usernameValid: usernameValid,
                validData: validData,
                onlyAddUser: widget.onlyAddUser,
                submitdata: _submitform,isLoginMode: isLoginMode,)))
    );
  }
}
