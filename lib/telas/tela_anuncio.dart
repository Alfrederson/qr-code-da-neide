import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_reader/component/banner_anuncio.dart';
import '../component/botao_grande.dart';

class TelaAnuncio extends StatelessWidget{
  final Widget Function() proximaTela;
  const TelaAnuncio( {super.key, required this.proximaTela} );

  void _fecharAnuncio(BuildContext ctx){
    Navigator.pop(ctx);
    Navigator.push(ctx,MaterialPageRoute(builder: (issoNaoImporta) => proximaTela()));
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
                    child: const BannerAnuncio(tamanho: AdSize.mediumRectangle)
                  )
                ]
              )
          )
            ,
          Container(
            padding: const EdgeInsets.all(10),
            child: BotaoGrande(texto: "Continuar", onPressed:  () => _fecharAnuncio(context))
          )
        ] 
      )
    );
  }
}