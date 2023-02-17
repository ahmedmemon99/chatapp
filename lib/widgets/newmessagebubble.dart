import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewMessageBubble extends StatelessWidget {
  const NewMessageBubble(
      {Key? key,
        required this.deviceSize,
        required this.isMe,
        required this.messageData,
        required this.time}) : super(key: key);

  final Size deviceSize;
  final bool? isMe;
  final String? messageData;
  final DateTime? time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe! ? Alignment.topRight : Alignment.topLeft,
      child: Column(
        crossAxisAlignment: isMe! ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
             color: isMe! ? Color.fromARGB(255, 112, 62, 254): Colors.white,
              borderRadius: isMe! ?
              BorderRadius.only(topRight: Radius.circular(17),topLeft: Radius.circular(17),bottomLeft:Radius.circular(17) ) :
              BorderRadius.only(topRight: Radius.circular(17),topLeft: Radius.circular(17),bottomRight: Radius.circular(17))
            ),
            margin: EdgeInsets.only(top: 5,bottom: 2,left: 10,right: 10),
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                Text(messageData!,style: TextStyle(color: isMe! ?Colors.white : Colors.black ,fontFamily: 'Roboto mono' )),
              ],
            ),
          ),
          Container(
         margin:  EdgeInsets.symmetric(horizontal: 15,vertical: 3),
            child: Align(
              alignment:isMe! ? Alignment.topRight : Alignment.topLeft,
              child: Text(DateFormat('jms').format(time!),style: TextStyle(color: iconColor),)),),
          SizedBox(height: 15,)
        ],
      ),
    );
  }
}
