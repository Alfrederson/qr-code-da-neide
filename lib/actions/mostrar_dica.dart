import 'package:flutter/material.dart';


void mostrarDica(String dica, BuildContext context){

    var toast = SnackBar(
            dismissDirection: DismissDirection.none,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 200,
              right: 20,
              left: 20
            ),
            backgroundColor: Theme.of(context).primaryColor,
            content: Text(
                      dica,
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                                fontSize:24,
                                color: Theme.of(context).backgroundColor
                              )
                          ),
            duration: const Duration(seconds: 2));
    ScaffoldMessengerState s = ScaffoldMessenger.of(context);
    s.removeCurrentSnackBar();
    s.showSnackBar(toast);
}