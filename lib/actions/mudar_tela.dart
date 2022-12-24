import 'dart:math';
import 'package:flutter/material.dart';
import '../telas/tela_anuncio.dart';

Function() mudarTela(BuildContext context, Widget Function () qualTela, {bool pularAnuncio = false}){ 
  final rnd = Random();
  return () {
      // a ideia era mostrar o anuncio sempre a cada 8 vezes que isso é chamado, mas preferi
      // fazer um esquema tipo aleatório
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>
          !pularAnuncio && rnd.nextInt(100) < 10 ?
            TelaAnuncio(proximaTela: qualTela) :
            qualTela()
        )
      );
  };
}