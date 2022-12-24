
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_reader/actions/mostrar_dica.dart';
import 'package:qr_reader/component/botao_horizontal.dart';
import '../component/titulo.dart';

// dart é tanta palavra chave que não dá pra entender o que está aconteseno

class TelaLeitorQr extends StatefulWidget{
  const TelaLeitorQr({Key? key}) : super(key:key);

  static TelaLeitorQr make(){
    return const TelaLeitorQr();
  }

  @override
  State<TelaLeitorQr> createState() => _TelaLeitorQrState();


  static Future<String?> show({
    required BuildContext context
  }) async =>
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const TelaLeitorQr()
      )
    );
  
}

// o state também o que gera os elementos da UI.
// esquisito.
class _TelaLeitorQrState extends State<TelaLeitorQr>{
  String qrLido = "(Leitura vai aparecer aqui)";
  bool leuQr = false;
  bool flashLigado =false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  // tem que pausar a câmera se for android ou continuar a camera se for ios
  // não sei por que, tava num exemplo
  // nunca vou ter ifone pra testar isso
  @override
  void reassemble(){
    super.reassemble();
    if(Platform.isAndroid){
      controller.pauseCamera();
    }else if(Platform.isIOS){
      controller.resumeCamera();
    }
  }

  void _copiar(){
    // notificação?
    mostrarDica('Texto copiado para a área de transferência', context);
    
    Clipboard.setData(ClipboardData(text: qrLido));
  }

  void _copiarESair(){
    _copiar();
    SystemNavigator.pop();
  }

  void _maisUm(){
    setState((){
      qrLido = "";
      leuQr = false;
    });
    controller.resumeCamera();
  }

  void _alternarFlash(){
    controller.toggleFlash();
    controller.getFlashStatus().then( (status) => 
      setState( (){
        flashLigado = status! ;
      })
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titulo(context,"Leitor de QR Code"),
      body: Column(
        children:[
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  formatsAllowed: const [BarcodeFormat.qrcode]
                ),
                IconButton(
                  color:  Colors.white,
                  padding: const EdgeInsets.all(32),
                  iconSize: 32,
                  icon: Icon(
                    flashLigado ? 
                      const IconData(0xf081, fontFamily: 'MaterialIcons') :
                      const IconData(0xf082, fontFamily: 'MaterialIcons')
                  ),
                  onPressed: _alternarFlash,
                ),
                if(leuQr) 
                  SingleChildScrollView(
                    child:Column(
                      children:[
                        Container(
                          padding: const EdgeInsets.all(24),
                          color: const Color.fromARGB(150, 0, 0, 0),
                          child: Text(qrLido, style: const TextStyle(fontFamily: 'Monospace', fontSize:20, color: Colors.white))
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          height:100,
                          child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BotaoHorizontal("Copiar", onLongPress: _copiarESair, onPressed: _copiar),
                                    BotaoHorizontal("Ler outro",onPressed: _maisUm)                
                                  ])
                        )                        
                      ]
                    )
                  )
              ]
            )
          )
            
        ]
      )
    );
  }

  // acho que é um callback que é chamado quando
  // o qrseiláoque é criado, aí esse callback faz
  // com que o controller que tá declarado lá em cima 
  // receba a atribuição desse aqui
  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream
              .where((scanData) => scanData.format == BarcodeFormat.qrcode)
              .listen((scanData) { setState( (){
      qrLido = scanData.code!;
      leuQr = true;
      controller.pauseCamera();
    }); });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }
}


