import 'dart:developer';

import 'package:chatappwithfirebase/utils/regular_expressions.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/AuthFromTextField.dart';
import 'package:chatappwithfirebase/widgets/imagepick.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'Dropdownwidget.dart';

class MyBehavior extends ScrollBehavior{
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
class NewAuthForm extends StatefulWidget {
   NewAuthForm({
     Key? key,
     required this.submitdata,
     required this.isLoginMode,
     required this.emailKey,
     required this.usernameKey,
     required this.passwordKey,
     this.onlyAddUser =false,
     required this.emailValid,
     required this.passwordValid,
     required this.usernameValid,
     required this.validData,
   }) : super(key: key);

  final void Function(String email,String username,String password,bool isLogged,BuildContext context,bool isLoading,[File image,Map<String,Map<String,String>>? locationdata]) submitdata;
  bool isLoading =false;
  bool isLoginMode;
  final GlobalKey<FormFieldState> emailKey;
  final GlobalKey<FormFieldState> passwordKey;
  final GlobalKey<FormFieldState> usernameKey;
   bool onlyAddUser;
   bool emailValid;
   bool passwordValid;
   bool usernameValid;
   bool validData;

  @override
  State<NewAuthForm> createState() => _NewAuthFormState();
}

class _NewAuthFormState extends State<NewAuthForm>{

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  void dispose() {
    widget.isLoading = false;
    super.dispose();
  }
  @override
  void initState() {
    widget.isLoginMode =widget.onlyAddUser;
    super.initState();
  }

  String email ='';
  String password ='';
  String username ='';
  var selectedImage;

  final _usernameFocus =FocusNode();
  final _emailFocus =FocusNode();
  final _passwordFocus =FocusNode();

  void selectedImageFu(File image){
    selectedImage =image;
  }

  final fieldKey = GlobalKey<FormFieldState>();
  var _emailAutoValidate =AutovalidateMode.disabled;
  var _UsernameAutoValidate =AutovalidateMode.disabled;

  bool emailFocus =false;
  bool passwordFocus =false;
  bool usernameFocus =false;

  void _submit(){
    setState(() {
      _emailAutoValidate =AutovalidateMode.onUserInteraction;
      _UsernameAutoValidate =AutovalidateMode.onUserInteraction;
      emailFocus =false;
      usernameFocus =false;
      _emailFocus.unfocus();
      if(!widget.isLoginMode){_usernameFocus.unfocus();}
      print('password:${_passwordFocus.hasFocus}');
       });
      if(widget.isLoginMode){
        final bool logEmailValid=widget.emailKey.currentState!.validate();
        final bool logPwdValid =widget.passwordKey.currentState!.validate();
         if(logEmailValid && logPwdValid) {
            widget.emailValid =true;
            widget.passwordValid=true;
             widget.emailKey.currentState!.save();
             widget.passwordKey.currentState!.save();
             setState(() {
               widget.validData =true;
             });
             widget.submitdata(
                 email, username, password, widget.isLoginMode, context,
               widget.isLoading);
         }
         setState(() {
           if(!logEmailValid){widget.emailValid =false;}
           if(!logPwdValid){widget.passwordValid =false;}
         });
         }
      else if(selectedImage != null && !widget.isLoginMode){
        setState(() {
        });
        final bool regUsernameValid= widget.usernameKey.currentState!.validate();
        final bool regEmailValid=  widget.emailKey.currentState!.validate();
        final bool regPwdValid= widget.passwordKey.currentState!.validate();
          if( regEmailValid && regPwdValid  && regUsernameValid) {

                 widget.emailValid =true;
                widget.passwordValid=true;
                widget.usernameKey.currentState!.save();
                widget.emailKey.currentState!.save();
                widget.passwordKey.currentState!.save();
                setState(() {
                  widget.validData =true;
                });
                widget.submitdata(
                  email,
                  username,
                  password,
                  widget.isLoginMode,
                  context,
                  widget.isLoading,
                  selectedImage!,
                  values
                );
              }
                setState(() {
                  if(!regEmailValid){widget.emailValid =false;}
                  if(!regPwdValid){widget.passwordValid =false;}
                  if(!regUsernameValid){widget.usernameValid =false;}
                });
        }else{
        final bool regUsernameValid= widget.usernameKey.currentState!.validate();
        final bool regEmailValid=  widget.emailKey.currentState!.validate();
        final bool regPwdValid= widget.passwordKey.currentState!.validate();
        setState(() {
          if(!regEmailValid){widget.emailValid =false;}
          if(!regPwdValid){widget.passwordValid =false;}
          if(!regUsernameValid){widget.usernameValid =false;}
        });
        setState(() {
          widget.isLoading =false;
        });
        showDialog(context: context, builder: (context){
          return const AlertDialog(
            icon: Icon(Icons.image,color: Colors.purple,),
            title: Text('Please select image'),
          );
        });
      }
  }

  String? emailValidation (String? val){
      widget.emailValid =true;
      if(emailFocus){
        widget.emailValid =true;
        return null;
      }
      if(!val!.isValidEmail()){
        widget.emailValid =false;
        widget.validData =false;
        return 'Enter valid Address';
      }
      return null;
  }

  String? passwordValidation (String? val){
      widget.passwordValid =true;
      if(val!.isEmpty || val.length < 8){
      widget.passwordValid =false;
      widget.validData =false;
      return 'Enter password minimum 8  characters';
      }
      return null;
   }

  String? usernameValidation (String? val){
      widget.usernameValid =true;
      if(usernameFocus){
        widget.usernameValid =true;
        return null;
      }
       if(val!.isEmpty || val.length < 5){
        widget.usernameValid =false;
        widget.validData =false;
        return 'Enter username';
      }
      return null;
  }

 ScrollController controller =ScrollController();


  Map<String,Map<String,String>> values ={
    'country': {'name': '','id': ''},
    'state': {'name': '','id': ''},
    'city': {'name': '','id': ''},
  };
  void passData(Map<String,Map<String,String>> value){

    values = value;

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize =MediaQuery.of(context).size;
    return CustomScrollView(
      scrollBehavior: MyBehavior(),
      controller: controller,
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
                children: [
                  buildHeaderText(),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black54,blurRadius: 3,spreadRadius: 1)
                      ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                        height: widget.validData ? !widget.isLoginMode ? deviceSize.height * 0.82 : deviceSize.height * 0.4:
                        !widget.isLoginMode ? deviceSize.height * 0.92 : deviceSize.height * 0.44,
                        width: double.infinity,
                        child: Column(
                            children: [
                              Form(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                                        child:!widget.onlyAddUser ? Text('Add Friend',style: TextStyle(fontSize: 25),): !widget.isLoginMode? Text('Create account',style: TextStyle(fontSize: 25),): Text('Sign in',style: TextStyle(fontSize: 25),),
                                      ),
                                      if(!widget.isLoginMode)Center(child: ImagePick(contxt: context, imagePickFun: selectedImageFu)),
                                      if(!widget.isLoginMode) buildUsernameTextField(),
                                      buildEmailTextField(),
                                      buildPasswordTextField(),
                                      if(!widget.isLoginMode)
                                        DropDownWidget(passData: passData,)
                                    ],
                                  )),
                              Spacer(),
                              !widget.isLoading ? buildSubmitButton() : CircularProgressIndicator(),
                              Spacer(),
                              if(widget.emailKey.currentState != null &&
                                  widget.passwordKey.currentState != null &&
                                  widget.usernameKey.currentState != null
                              ) SizedBox(height: 35,)
                       ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUsernameTextField(){
    return AuthFormTextField(
      onSubmit: (val){
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      onChange: (val){

        if(val.isNotEmpty){
          setState(() {
            usernameFocus=true;
            widget.usernameValid = true;
          });
        }},
      autoValidation: _UsernameAutoValidate,
      fieldKey: widget.usernameKey,
      focusNode: _usernameFocus,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(usernameExpression))
      ],
      isValid: widget.usernameValid,
      lableText: 'Username',
      inputValidation: usernameValidation,
      onSave: (val){
        username =val!;
      },
    );
  }

  Widget buildEmailTextField(){
    return
      AuthFormTextField(
        onSubmit: (val){
          if(widget.emailKey.currentState!.hasError) {
            emailFocus=false;
            widget.emailValid =false;
          }else{
                emailFocus=true;
              widget.emailValid =true;
          }
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
        onChange: (val){
          if(val.isNotEmpty){
            setState(() {
              emailFocus=true;
              widget.emailValid = true;
            });
          }},
        fieldKey: widget.emailKey,
        focusNode: _emailFocus,
        autoValidation: _emailAutoValidate,
        inputFormatters:
        [
          FilteringTextInputFormatter.allow(RegExp(emailEditingExpression)),
        ],
        isValid: widget.emailValid,
        lableText: 'Email Address',
        inputValidation: emailValidation,
        onSave: (val){
          email =val!;
        },
      );
  }

  Widget buildPasswordTextField(){
    return AuthFormTextField(
      focusNode: _passwordFocus,
      onFocusChange: (hasFocus){


      },
      fieldKey: widget.passwordKey,
      isValid: widget.passwordValid,
      lableText: 'password',
      inputValidation: passwordValidation,
      onSave: (val){
        password =val!;
      },);
  }


  Widget buildSubmitButton() {
    return FractionallySizedBox(
      widthFactor: 0.98,
      child: InkWell(
        onTap:_submit,
        child: Container(
          height: 50,
          child: Center(
              child:
              !widget.onlyAddUser ?
              Text('Add User', style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'roboto'),) :
              Text('Submit', style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'roboto'),)
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                  colors: [
                    buttonGradientFirstColor,
                    buttonGradientSecColor
                  ]
              )
          ),

        ),
      ),
    );
  }
  Widget buildHeaderText(){
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('FChat',style: TextStyle(color: Colors.white,fontSize: 50,fontFamily: 'roboto'),),
              Text(' 💛',style: TextStyle(color: Colors.white,fontSize: 35,fontFamily: 'roboto'))
            ],
          ),
          SizedBox(height: 5,),
          Text('Sign in or Request a New Account',
              style: TextStyle(color: Colors.white,fontSize: 30,fontFamily: 'robotoRegular',fontWeight: FontWeight.w500)
          )
        ],
      ),
    );
  }


}
