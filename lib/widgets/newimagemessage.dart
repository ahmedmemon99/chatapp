import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';

class NewImageBubble extends StatelessWidget {
   NewImageBubble(
      {Key? key,
        required this.deviceSize,
        required this.isMe,
        required this.messageData,
        required this.time,
        required this.isLoading
      }) : super(key: key);

  final Size deviceSize;
  final bool? isMe;
  final String messageData;
  final DateTime time;
  final bool isLoading;

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
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    child:
                    CachedNetworkImage(
                      imageUrl: messageData,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: CircularProgressIndicator(
                                color: isMe! ? Colors.white: accentColor,
                                value: downloadProgress.progress),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    borderRadius: BorderRadius.circular(15),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
            child: Align(
                alignment:isMe! ? Alignment.topRight : Alignment.topLeft,
                child: Text(DateFormat('jms').format(time),style: TextStyle(color: iconColor),)),),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}
