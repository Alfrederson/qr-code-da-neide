import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../actions/mudar_tela.dart';

import 'tela_leitor_qr.dart';
import 'tela_gerador_qr.dart';

import '../component/titulo.dart';
import '../component/botao_grande.dart';
import '../component/menu_central.dart';

class TelaHome extends StatelessWidget{
  const TelaHome({super.key});
  @override build(BuildContext context){
    // não mostor anuncio aqui porque é chato e a pessoa já viu os anúncio em
    // baixo
    // sim, é uma função que retorna uma função!
    final telaLeitor = mudarTela(context, TelaLeitorQr.make, pularAnuncio: true );
    final telaGerador = mudarTela(context, TelaGeradorQr.make, pularAnuncio: true );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: titulo(context,"Leitor QRCode da Neide"),
      body : menuCentral([
              BotaoGrande(texto: "Ler QR", onPressed: telaLeitor ),
              BotaoGrande(texto: "Fazer QR", onPressed:  telaGerador ),
              BotaoGrande(texto: "Sair", onPressed: () =>  SystemNavigator.pop() )
            ])
    );
  }
}
