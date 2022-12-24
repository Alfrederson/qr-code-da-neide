import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_reader/component/banner_anuncio.dart';
import '../component/botao_grande.dart';

class TelaAnuncio extends StatefulWidget{
  // proximaTela é uma função que muda para a próxima tela.
  final Widget Function() proximaTela;
  const TelaAnuncio( {super.key, required this.proximaTela} );
  
  @override
  State<StatefulWidget> createState() => _TelaAnuncioState();
}

class _TelaAnuncioState extends State<TelaAnuncio>{
  
  bool telaLiberada = false;
  late Timer t;

  void _fecharAnuncio(BuildContext ctx){
    Navigator.pop(ctx);
    Navigator.push(ctx,MaterialPageRoute(builder: (issoNaoImporta) => widget.proximaTela()));
  }

  @override
  void initState(){
    super.initState();
    t = Timer(
      const Duration(milliseconds: 1000),
      (){
        setState( (){
          log("Liberando mesmo sem ad.");
          telaLiberada=true;
        });
      }
    );
  }

  @override
  void dispose(){
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children : [
          Expanded(
              child:Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    constraints: const BoxConstraints(maxHeight: 500,maxWidth: 320),
                    child: BannerAnuncio(
                             tamanho: AdSize.mediumRectangle,
                                adCarregado: (){
                                  setState((){
                                    telaLiberada=true;
                                  });
                                },)
                  )
                ]
              )
          )
            ,
          Container(
            width:double.infinity,
            padding: const EdgeInsets.all(10),
            child: 
              telaLiberada ?
                BotaoGrande(texto: "Continuar", onPressed:  () => _fecharAnuncio(context)) :
                LinearProgressIndicator( color: Theme.of(context).primaryColor)
          )
        ] 
      )
    );
  }
}