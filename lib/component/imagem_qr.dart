import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

// Fazendo componente como classe.


class ImagemQR extends StatelessWidget{
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final String data;
  final String etiqueta;
  final bool textoOculto;
  final bool podeCompartilhar;

  // const TelaGeradorQr({super.key});
  const ImagemQR({
    super.key, 
    required this.data,
    this.etiqueta="",
    this.textoOculto=false,
    this.podeCompartilhar=false,
    this.onPressed,
    this.onLongPress});
  
  Padding figurinha({bool ocultarTexto = false}){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        children:[
          Text(data.isNotEmpty && etiqueta.isNotEmpty? etiqueta : "Plaquinha de Pix", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, color: Colors.black)),
          data.isEmpty ? 
            const Text("O QR Code vai aparecer aqui.") :
            QrImage( data : data, version : QrVersions.auto, size: 250),
          if(data.isNotEmpty && !ocultarTexto) Text( data, style : const TextStyle(fontFamily: "Monospace", color: Colors.black) ),
        ]
      ));
  }

  void _compartilhar() async{
    final directory = (await getApplicationDocumentsDirectory ()).path;
    final imagePath = await File('$directory/plaquinha.png').create();

    var imagem = await ScreenshotController().captureFromWidget(
      Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: figurinha(ocultarTexto: true),
      )
    );
    await imagePath.writeAsBytes(imagem);
    ShareExtend.share(imagePath.path,
                      "image",
                      sharePanelTitle: "Compartilhar $etiqueta com",
                      subject: "QR code de $etiqueta");
  }

  void  _longPress() async{
    if(data.isEmpty)
      return;
    if(podeCompartilhar) _compartilhar();
    if(onLongPress != null) onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onLongPress : _longPress,
      child : figurinha(ocultarTexto: textoOculto)
    );
  }

}