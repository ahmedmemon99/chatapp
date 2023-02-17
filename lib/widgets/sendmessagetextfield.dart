import 'dart:convert';
import 'dart:math';

import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SendMessageTextField extends StatefulWidget {
   SendMessageTextField({
     required this.toTokens,
     required this.txtMessage,
     required this.toUserId,
     required this.scrollController,
     Key? key,
  }) : super(key: key);

  final toUserId;
  final List toTokens;
  final TextEditingController txtMessage;
  final ScrollController scrollController;
  File? selectedImage;


  @override
  State<SendMessageTextField> createState() => _SendMessageTextFieldState();
}

class _SendMessageTextFieldState extends State<SendMessageTextField> {

  final currentUserdata = FirebaseAuth.instance.currentUser;
  int randomnumber = Random().nextInt(100);

  void shareImage (ImageSource imageSource)async{
       Navigator.of(context).pop();
       try{
          final ImagePicker pref = ImagePicker();
          XFile? clickedImage =await pref.pickImage(source: imageSource,imageQuality: 50,maxHeight: 200,maxWidth: 200);
          widget.selectedImage = await File(clickedImage!.path);
          final storage =FirebaseStorage.instance.ref().child('User_image').child(FirebaseAuth.instance.currentUser!.uid +randomnumber.toString() +'.jpg');
          await storage.putFile(widget.selectedImage!);
          String imageUrl =await storage.getDownloadURL();

          await FirebaseFirestore.instance.collection('chat').doc('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').
          collection('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').add(
          {
          'messageData' : imageUrl,
          'time' : DateTime.now(),
          'userid':FirebaseAuth.instance.currentUser!.uid,
          'isTextMessage': false,
          });
          await FirebaseFirestore.instance.collection('chat').doc('${widget.toUserId}${FirebaseAuth.instance.currentUser!.uid}').
          collection('${widget.toUserId}${FirebaseAuth.instance.currentUser!.uid}').add(
          {
              'messageData' : imageUrl,
              'time' : DateTime.now(),
              'userid':FirebaseAuth.instance.currentUser!.uid,
              'isTextMessage': false,
          });
          widget.txtMessage.clear();
          widget.scrollController.animateTo(widget.scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
         }catch(e){
     }
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35) ,topRight: Radius.circular(35))
      ),
      child: Container(
        alignment: Alignment.center,
        child: TextField(
          keyboardType: TextInputType.multiline,
          controller: widget.txtMessage,
          decoration: InputDecoration(
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: ()async{
                    if(widget.txtMessage.text.isEmpty){
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message is empty'),duration: Duration(milliseconds: 10),));
                    }
                    else{
                        var message =widget.txtMessage!.text;
                        widget.txtMessage.clear();
                         try{
                         await FirebaseFirestore.instance.collection('chat').doc('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').
                          collection('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').add(
                             {
                               'messageData' : message,
                               'time' : DateTime.now(),
                               'userid':FirebaseAuth.instance.currentUser!.uid,
                               'isTextMessage': true,

                             });
                          await FirebaseFirestore.instance.collection('chat').doc('${widget.toUserId}${FirebaseAuth.instance.currentUser!.uid}').
                            collection('${widget.toUserId}${FirebaseAuth.instance.currentUser!.uid}').add(
                              {
                               'messageData' : message,
                               'time' : DateTime.now(),
                               'userid':FirebaseAuth.instance.currentUser!.uid,
                               'isTextMessage': true,
                              });
                         widget.scrollController.animateTo(widget.scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
                        }catch(e){
                          print(e);
                        }

                        var sender = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
                         print(await FirebaseMessaging.instance.getToken());
                        sendNotification(widget.toTokens,sender['username'],message);
                  }
                  },
                  icon:Icon(Icons.send,color: iconColor,size: 35,)),

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(onPressed: (){
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
                                       onTap: () => shareImage(ImageSource.camera) ,
                                        leading: const Icon(Icons.camera_enhance,color: Colors.pink,),
                                        title: const Text('Capture Image',style: TextStyle(color: Colors.grey),),
                                    ),
                                    ListTile(
                                        onTap: () => shareImage(ImageSource.gallery),
                                        leading: const Icon(Icons.image_sharp,color: Colors.purple,),
                                        title: const Text('Select Image',style: TextStyle(color: Colors.grey),)
                                    )
                                  ],
                                ),
                              );
                            });
                    },      icon: Icon(Icons.camera_enhance,color: iconColor,size: 35,),)
                  ),

                ],),
              contentPadding: EdgeInsets.only(left: 30,top: 40,bottom: 0),
              hintStyle: TextStyle(color: Colors.grey.shade400,fontWeight: FontWeight.w500,fontSize: 17),
              hintText: 'Type here....',
              filled: true,
              fillColor: Color.fromARGB(255, 246, 246, 246),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(40))
              )
          ),
        ),
      ),
    );
  }
}


Future<void> sendNotification(List tokens,String sender,String message)async {
  try{
  await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'Key=AAAAi7MnNi0:APA91bG3FUF58J-A4BMnKjxwzJKyv4d_bAS-PWTJmZPl_8gQc2Ss8lrfbWS1NM2rwgdsN6N7dfYp7p7jCmkAoOqJjch8YI7RTu_kjIacwRX4wJkHhA9yiKCBxo3xAE39KRnLSxdh6VaP',
        'Content-Type': 'application/json'
      },
      body: json.encode(
        {
          'registration_ids':tokens,
          "notification": {
            "body": message,
            "title": sender,
            "sound": false
          }
        }
      )

  );
  print('done');
}catch(e){
  print('error $e');
}
}