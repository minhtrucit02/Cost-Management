import 'package:flutter/material.dart';

class AppValidator {

  String? validateUsername(value){
    if(value!.isEmpty){
      return 'Please enter a username';
    }
    return null;
  }

  String? validateEmail(value){
    if(value!.isEmpty){
      return 'Please enter a email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegExp.hasMatch(value)){
      return 'Please enter a email';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? isEmptyCheck(value){
    if(value!.isEmpty){
      return 'Please fill details';
    }
    return null;
  }

}