import 'package:chatappwithfirebase/widgets/newmessagebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../widgets/customappbar.dart';
import '../widgets/newimagemessage.dart';
import '../widgets/sendmessagetextfield.dart';

class NewChatScreen extends StatefulWidget {
   NewChatScreen({
    Key? key,
    required this.toUsedId,
    required this.username,
     required this.tokens,
    required this.profileImageUrl,
     required this.toUserEmail,
     required this.country,
     required this.state,
     required this.city
  }) : super(key: key);

  final String username;
  final String profileImageUrl;
  final String toUserEmail;
  final String toUsedId;
   final String country;
   final String state;
   final String city;
   final List tokens;
  bool? isMe;
  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  TextEditingController? txtMessage;
  final scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    txtMessage =TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 246),
      appBar: PreferredSize(
          preferredSize: Size(double.infinity,MediaQuery.of(context).size.height *0.095),
          child: CustomAppBar(
                country: widget.country,
               state: widget.state,
               city: widget.city,
               emailAddress: widget.toUserEmail,
              deviceSize: MediaQuery.of(context).size,
              username: widget.username,
              profileImageUrl: widget.profileImageUrl,
          ),),
      body: Column(
        children: [
          StreamBuilder(
               stream: FirebaseFirestore.instance.collection('chat').
               doc('${FirebaseAuth.instance.currentUser!.uid}${widget.toUsedId}').
               collection('${FirebaseAuth.instance.currentUser!.uid}${widget.toUsedId}').orderBy('time',descending: false).snapshots(),
               builder: (context,snap){
                 if(!snap.hasData){
                   return Expanded(
                       flex: 11,
                       child: Center(child: CircularProgressIndicator(color: accentColor,),));
                 }
                 if(snap.connectionState == ConnectionState.waiting){
                         isLoading = true;
                  }
                return Expanded(
                flex: 11,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (context,index){
                      if(snap.data!.docs[index]['userid'] ==FirebaseAuth.instance.currentUser!.uid ){
                        widget.isMe =true;
                      }
                      else{
                        widget.isMe =false;
                      }
                      if(!snap.data!.docs[index]['isTextMessage']) {
                          return NewImageBubble(
                            isLoading: isLoading,
                            messageData: snap.data!.docs[index]['messageData'],
                            isMe: widget.isMe,
                            time: snap.data!.docs[index]['time'].toDate(),
                            deviceSize: MediaQuery.of(context).size,);
                         }
                          return NewMessageBubble(
                           messageData: snap.data!.docs[index]['messageData'],
                           isMe: widget.isMe,
                           time: snap.data!.docs[index]['time'].toDate(),
                            deviceSize: MediaQuery.of(context).size,);
                    }));
              }),
              SendMessageTextField(
                toTokens: widget.tokens,
                scrollController: scrollController,
                toUserId: widget.toUsedId,
                txtMessage: txtMessage!,
              )
        ],
      ),
    );
  }
}



