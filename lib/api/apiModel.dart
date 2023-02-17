import 'dart:convert';
import 'dart:developer';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:http/http.dart' as http;


class ApiModel {

  int userId;
  int postId;
  String title;
  String body;

  ApiModel(
      {required this.userId, required this.postId, required this.title, required this.body});
}

  Future fetchData() async{
    Uri url = Uri.parse('$apiUrl/posts');
    http.Response response = await http.get(url);
    final data =json.decode(response.body);
    return data;
}

Future SinglePostItem(String postId) async{
  Uri url = Uri.parse('$apiUrl/comments?postId=$postId');
  http.Response response = await http.get(url);
  var data =json.decode(response.body);
  log(response.body);
  return data;
}

Future albumApiData ()async{
  Uri url =Uri.parse('https://jsonplaceholder.typicode.com/photos');
  http.Response response =await http.get(url);
  var data = json.decode(response.body);
  print(data);
  return data;
}

