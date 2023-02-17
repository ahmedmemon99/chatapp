import 'dart:io';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePick extends StatefulWidget {
   ImagePick({Key? key,required this.contxt,required this.imagePickFun}) : super(key: key);

   final void Function(File selectedimage) imagePickFun;
   final BuildContext contxt;
  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {

  File? selectedImage;

  final _picker =ImagePicker();

  Future<void> clickImage()async{
    Navigator.of(context).pop();
    final clickedImage =await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
    setState((){
      selectedImage =File(clickedImage!.path);
      widget.imagePickFun(selectedImage!);
    });
  }

   Future<void> galleryImage(BuildContext context)async{
    Navigator.of(context).pop();
     final clickedImage =await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
     setState((){
      selectedImage =File(clickedImage!.path);
      widget.imagePickFun(selectedImage!);
     });
   }

  void _showImagePickOptions(context){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft :Radius.circular(20),topRight:Radius.circular(20) )),
        context: context,
        builder: (context){
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:  [
                ListTile(
                  onTap: clickImage ,
                  leading: const Icon(Icons.camera_enhance,color: Colors.pink,),
                  title: const Text('Capture Image',style: TextStyle(color: Colors.grey),),
                ),
                ListTile(
                    onTap:() => galleryImage(context),
                    leading: const Icon(Icons.image_sharp,color: Colors.purple,),
                    title: const Text('Select Image',style: TextStyle(color: Colors.grey),)
                )
              ],
            ),
          );
        });
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:selectedImage != null ? FileImage(selectedImage!): null,
          backgroundColor: authFromBackgroundSecColor,radius: 40,
        ),
        TextButton.icon(
            style: const ButtonStyle().copyWith(
              foregroundColor: const  MaterialStatePropertyAll(buttonGradientSecColor),
              textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 16))
            ),
            onPressed: (){
              _showImagePickOptions(widget.contxt);
            }, icon: const Icon(Icons.image,color: buttonGradientFirstColor,), label: const Text('Add image'))
      ],
    );
  }
}
