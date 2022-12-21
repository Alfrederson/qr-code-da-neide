import 'package:flutter/material.dart';


void mostrarDica(String dica, BuildContext context){

    var toast = SnackBar(
            backgroundColor: Colors.white,
            content: Text(
                      dica,
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                                fontSize:24,
                                color: Theme.of(context).primaryColor
                              )
                          ),
            duration: const Duration(seconds: 2));
    ScaffoldMessengerState s = ScaffoldMessenger.of(context);
    s.removeCurrentSnackBar();
    s.showSnackBar(toast);
}