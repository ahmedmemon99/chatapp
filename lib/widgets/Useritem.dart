import 'package:chatappwithfirebase/Screens/newchatscreen.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class CustomImageProvider extends ImageProvider<NetworkImage>{
  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    // TODO: implement obtainKey
    throw UnimplementedError();
  }
}

class  UserItem extends StatefulWidget {
  const UserItem(
      {
        Key? key,
        required this.deviceSize,
        required this.username,
        required this.imageUrl,
        required this.toUserId,
        required this.toUserEmail,
        required this.country,
        required this.state,
        required this.city,
        required this.token
      }) : super(key: key);


      final Size deviceSize;
      final String username;
      final String imageUrl;
      final String toUserId;
      final String toUserEmail;
       final String country;
        final String state;
        final String city;
        final List token;

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:  EdgeInsets.only(left:widget.deviceSize.width * 0.02 ,right: widget.deviceSize.width * 0.02,bottom: widget.deviceSize.height * 0.02),
        child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        tileColor: Colors.white,
        leading: CircleAvatar(
          // child: Image.network(widget.imageUrl,loadingBuilder: (context,child,loading,){
          //   if(loading!.expectedTotalBytes != null) {
          //     return CircularProgressIndicator();
          //   }
          //   return CircularProgressIndicator();
          //
          // },),
          //child: CircularProgressIndicator(),
         backgroundImage:NetworkImage(widget.imageUrl),
        backgroundColor: accentColor,radius: 30,),
        title: Text(widget.username,style: TextStyle(fontFamily: 'Roboto'),),
        subtitle: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chat').
          doc('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').
          collection('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').orderBy('time',descending: true).snapshots(),
          builder: (context,snap) {
            try {
              if (snap.data?.docs.length == 0) {
                       return Text('');
                  }
              if(snap.data?.docs.first['isTextMessage']) {
                return Text(snap.data?.docs.first['messageData'],
                  style: TextStyle(color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,fontFamily: 'Roboto mono',),);
              }else{
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image,size: 15,),
                      SizedBox(width: 2,),
                      Text('Photo',
                        style: TextStyle(color: Colors.grey.shade500,
                            fontWeight: FontWeight.w200),),
                    ],
                  ),
                );
              }
            }catch(e){
            return Text('');
            }
          }
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 8.0,bottom: 32),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chat').
              doc('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').
              collection('${FirebaseAuth.instance.currentUser!.uid}${widget.toUserId}').orderBy('time',descending: true).snapshots(),
              builder: (context,snap) {
                try {
                  if (snap.data?.docs.length == 0) {
                    return Text('');
                  }
                  return Text(DateFormat('jm').format(snap.data!.docs.first['time'].toDate()).toString(),
                    style: TextStyle(color: Colors.grey),);
                }catch(e){
                  return Text(' ');
                }
              }
          )
        ),
        onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return NewChatScreen(
                  tokens: widget.token ,
                  country: widget.country,
                  state: widget.state,
                  city: widget.city,
                  toUserEmail: widget.toUserEmail,
                  username: widget.username,
                  profileImageUrl: widget.imageUrl,
                  toUsedId: widget.toUserId ,
                );
              }));
          },
      ),
    );
  }
}
