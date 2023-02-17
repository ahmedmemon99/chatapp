import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:chatappwithfirebase/widgets/newAuthForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/Useritem.dart';
import '../widgets/bottomnavigatonbar.dart';
import '../widgets/searchbar.dart';


class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<UsersScreen> {

  @override
  void initState() {
    getaAllUsers();
    super.initState();
  }

  var filterData;
  var txtUserSearch;

  Future<QuerySnapshot<Map<String, dynamic>>> getaAllUsers() async{
    final firebaseAllUsers =FirebaseFirestore.instance.collection('users');
    return firebaseAllUsers.get();
  }

  final currentUser =FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    final deviceSize =MediaQuery.of(context).size;
    return Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: deviceSize.width * 0.02),
            child: SearchBar(
                    deviceSize: deviceSize,
                    filterData: filterData ?? 'test 2',
                    onchange: (val){
                      setState(() {
                        txtUserSearch = val;
                      });
                    },
                  ),
                ),
         FutureBuilder(
          future: getaAllUsers(),
          builder: (context,userdata){
            try {
              if (userdata.hasData) {
                return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                        itemCount: userdata.data!.docs.length,
                        itemBuilder: (context, index) {
                          if (txtUserSearch == null ||
                              txtUserSearch.length == 0) {
                            if (currentUser!.uid !=
                                userdata.data!.docs[index].id) {
                              return UserItem(
                                token: userdata.data!.docs[index]['toToken'],
                                country: userdata.data!.docs[index]['country']['name'] ?? 'Not available',
                                state: userdata.data!.docs[index]['state']['name'] ?? 'Not available',
                                city: userdata.data!.docs[index]['city']['name'] ?? 'Not available',
                                toUserEmail: userdata.data!.docs[index]['email'],
                                deviceSize: deviceSize,
                                username: userdata.data!
                                    .docs[index]['username'],
                                imageUrl: userdata.data!
                                    .docs[index]['imageUrl'],
                                toUserId: userdata.data!.docs[index]['userId'],
                              );
                            }
                            else {
                              return Container();
                            }
                          }
                          else
                          if (userdata.data!.docs[index]['username'].startsWith(
                              txtUserSearch)) {
                            return UserItem(
                              token: userdata.data!.docs[index]['toToken'],
                              country: userdata.data!.docs[index]['country']['name'] ?? 'Not available',
                              state: userdata.data!.docs[index]['state']['name'] ?? 'Not available',
                              city: userdata.data!.docs[index]['city']['name'] ?? 'Not available',
                              toUserEmail: userdata.data!.docs[index]['email'],
                              deviceSize: deviceSize,
                              username: userdata.data!.docs[index]['username'],
                              imageUrl: userdata.data!.docs[index]['imageUrl'],
                              toUserId: userdata.data!.docs[index]['userId'],
                            );
                          }
                          return Container();
                        })
                );
              }
            }catch(e){
              print(e);
            }

                return Expanded(child: Center(child: CircularProgressIndicator(color:accentColor,),));
          }
           )
        ]
      );
     // bottomNavigationBar: BottomNavigation(),

   // );
  }
}
