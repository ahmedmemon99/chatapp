import 'package:chatappwithfirebase/api/apiModel.dart';
import 'package:chatappwithfirebase/widgets/PostDetails.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ApiDataViewScreen extends StatefulWidget {
  const ApiDataViewScreen({Key? key,required this.postId,}) : super(key: key);

  final int postId;

  @override
  State<ApiDataViewScreen> createState() => _ApiDataViewScreenState();
}

class _ApiDataViewScreenState extends State<ApiDataViewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details'),backgroundColor: accentColor,),
      body: FutureBuilder(
        future: SinglePostItem(widget.postId.toString()),
        builder: (context,data){
          if(data.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: accentColor,),);
          }
         return ListView.builder(
           itemCount: data.data.length,
            itemBuilder: (context,index){
              return  PostDetails(
                title: data.data[index]['name'],
                body: data.data[index]['body'],
              );
            },
          );
        },
      )
    );
  }
}
