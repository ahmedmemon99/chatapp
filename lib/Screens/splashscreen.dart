import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize =MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage(backgroundImage),
              fit: BoxFit.cover
          )
        ),
        child:CustomScrollView(
          slivers:  [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: deviceSize.height * 0.012),
                      height: deviceSize.height * 0.5,
                      child: Image.asset(splashImage),
                    ),
                    SizedBox(height: deviceSize.height *0.02,),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 1
                            )
                          ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(40) ,topRight: Radius.circular(40))
                        ),
                        child: Column(
                          children: [
                            SizedBox(height:deviceSize.height *0.06,),
                            Text('Enjoy the new experience of',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                            Text('chatting with global friends',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
                            SizedBox(height:deviceSize.height *0.02,),
                            Text('Connect people around the world for free',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.grey.shade400)),
                            SizedBox(height:deviceSize.height *0.07,),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 4,
                                  shadowColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color.fromARGB(255, 112, 62, 254)
                                ),
                                onPressed: (){
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen(onlyAddUser: true,)));
                                }, child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 95,vertical: 18),
                                  child: Text('Get Started',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                                )),
                            SizedBox(height:deviceSize.height *0.04,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Powered by',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: Colors.grey)),
                                SizedBox(width: deviceSize.width * 0.01,),
                                Icon(Icons.window_rounded,color: Colors.deepPurple,size: 11,),
                                SizedBox(width: deviceSize.width * 0.01,),
                                Text('ussage',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.deepPurple)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            ),
          ],
        ),
        ) ,
     );
   }
}
