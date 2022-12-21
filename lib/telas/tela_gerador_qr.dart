import 'package:flutter/material.dart';
import '../component/titulo.dart';
import '../component/botao_grande.dart';
import '../component/menu_central.dart';

import '../actions/mudar_tela.dart';

import 'tela_gerador_pix.dart';
import 'tela_gerador_texto.dart';

// Tem que ser stateful.
class TelaGeradorQr extends StatelessWidget{
  static Widget make() => const TelaGeradorQr();

  const TelaGeradorQr({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: titulo(context,"Gerador de QR code"),
      body: menuCentral([
              // mostro anuncio na plaquinha de pix porque eu que fiz
              // o código com base no manual do BC e a pessoa vai usar pra receber dinheiro.
              BotaoGrande(texto: "Plaquinha de PIX", onPressed: mudarTela(context, TelaGeradorPix.make)),
              BotaoGrande(texto: "QR de qualquer coisa", onPressed: mudarTela(context, TelaGeradorTexto.make, pularAnuncio: true),)
          ])
    );
  }
}