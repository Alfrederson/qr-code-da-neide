import 'package:flutter/material.dart';

AppBar titulo(BuildContext context, String text){
  return AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColor,
        title: Text(text, style: const TextStyle(fontFamily: "cursive", fontSize: 32, fontWeight: FontWeight.bold),)
      );
}

