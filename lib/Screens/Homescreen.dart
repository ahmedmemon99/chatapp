import 'package:chatappwithfirebase/api/apiModel.dart';
import 'package:chatappwithfirebase/Screens/apiitem.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return FutureBuilder(
       future: fetchData(),
       builder: (context,data){
         if(data.connectionState ==ConnectionState.waiting){
           return Center(child: CircularProgressIndicator(),);
         }
     return SizedBox(
         child: ListView.builder(
           itemCount: data.data!.length ,
           itemBuilder: (context,index){
         return ApiItem(title: data.data![index]['title'],body: data.data![index]['body'],postId: data.data![index]['id'],);
      }));
     
   });
   
  }
}
