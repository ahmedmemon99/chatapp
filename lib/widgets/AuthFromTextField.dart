
import 'package:chatappwithfirebase/utils/regular_expressions.dart';
import 'package:chatappwithfirebase/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/services.dart';

class AuthFormTextField extends StatelessWidget {
   const AuthFormTextField({
    Key? key,
    this.focusNode,
    required this.lableText,
    required this.fieldKey,
    required this.inputValidation,
    required this.isValid,
    this.onFocusChange,
    this.onChange,
    this. autoValidation,
    required this.onSave,
    this.inputFormatters,
    this.onSubmit
  }) : super(key: key);

  final String lableText;
  final void Function(String val)? onChange;
  final String? Function(String? val) inputValidation;
  final AutovalidateMode? autoValidation;
  final bool isValid;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? val) onSave;
   final void Function(bool? hasfocus)? onFocusChange;
  final FocusNode? focusNode;
  final void Function(String val)? onSubmit;
  final GlobalKey<FormFieldState> fieldKey;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
            margin: EdgeInsets.only(bottom:10 ,left:10,right: 10 ),
            child: Focus(
              child: TextFormField(
                key: fieldKey,
                focusNode: focusNode,
                onFieldSubmitted: onSubmit ,
                autovalidateMode: autoValidation,
                onChanged: onChange,
                inputFormatters: inputFormatters ,
                textInputAction: TextInputAction.next,
                onSaved: onSave,
                validator: inputValidation,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder:  InputBorder.none,
                  label: Text(lableText,style: TextStyle(color: Colors.grey),),
                ),
              ),
            ),
        ),
        Positioned(
          child: Container(
            margin: isValid? EdgeInsets.only(bottom: 10 ,left: 10,right: 10): EdgeInsets.only(bottom: 35 ,left: 10,right: 10),
            height: 3 ,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                    colors: [
                      buttonGradientSecColor,
                      buttonGradientFirstColor
                    ]),
            ),
          ),
        ),
      ],
    );
  }
}
