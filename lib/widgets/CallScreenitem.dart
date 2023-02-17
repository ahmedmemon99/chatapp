import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../utils/utils.dart';


class CallScreenItem extends StatelessWidget {
  const CallScreenItem({
      Key? key,
      required this.postId,
      required this.title,
      required this.albumId,
      required this.imageURl
  }) : super(key: key);

  final String postId;
  final String albumId;
  final String title;
  final String imageURl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InkWell(
        onTap: (){
          showDialog(
              barrierDismissible: false,
              context: context, builder: (context){
            return Dialog(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PinchZoom(
                    //maxScale: 2.5,
                    resetDuration: Duration(seconds: 15),
                      child: Image.network(imageURl,)),
                  Positioned(
                  top: -15,
                  right:  -15,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: IconButton(onPressed: (){
                              Navigator.of(context).pop();
                            }, icon: Icon(Icons.close,color: Colors.white,))),
                      )),
                  ],
                ),
            );
          });
        },
        child: GridTile(
            footer: GridTileBar(title: Text(title),) ,
           child:

           Image.network(
             '$imageURl',loadingBuilder: (context,child,load){
               if(load == null){
                 return child;
               }
               return Center(child: CircularProgressIndicator(color: accentColor,));
           }

          ),
        ),
      ),
    );
  }
}
