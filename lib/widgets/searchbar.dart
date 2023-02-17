import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
   SearchBar({
        Key? key,
        required this.deviceSize,
        required this.filterData,
        required this.onchange

  }) : super(key: key);

  final Size deviceSize;
  //final TextEditingController txtSearch;
  final String filterData;
  final Function(String val) onchange;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: Container(
            margin: EdgeInsets.only(
                top: widget.deviceSize.height * 0.05,
                bottom:widget.deviceSize.height * 0.0010,
                left: widget.deviceSize.height * 0.017,
                right: widget.deviceSize.height * 0.017),
            padding: EdgeInsets.only(top: 25),
            child: TextField(
              onChanged: widget.onchange,
              decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight:FontWeight.w500,
                      fontSize: 17,
                  ),
                  hintText: 'Search message....',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      CupertinoIcons.search,color: iconColor,
                      size: 36,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  )
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            margin: EdgeInsets.only(top: 65),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 7 ),
            child: IconButton(
                onPressed: ()async {
                  await FirebaseAuth.instance.signOut();},
              icon:Icon(CupertinoIcons.doc_text_search,size: 36,color: iconColor,) ),
          ),
        )
      ],
    );
  }
}