import 'package:chatappwithfirebase/api/apiModel.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/CallScreenitem.dart';
import 'package:flutter/material.dart';


class CallScreen extends StatelessWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: albumApiData(),
        builder: (context,data){
          if(data.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(color: accentColor,),);
          }
          return
            GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                ),
                itemBuilder: (context,index){
                return CallScreenItem(
                  postId: data.data![index]['id'].toString(),
                  title: data.data![index]['title'],
                  imageURl: '${data.data![index]['thumbnailUrl']}.jpg',
                  albumId: data.data![index]['albumId'].toString(),
                );
                });




        });
  }
}
