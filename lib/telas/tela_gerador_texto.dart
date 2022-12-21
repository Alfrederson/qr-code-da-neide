import 'package:flutter/material.dart';
import 'package:qr_reader/actions/mostrar_dica.dart';

import 'package:qr_reader/component/entrada_texto.dart';
import 'package:qr_reader/component/titulo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/botao_grande.dart';
import '../component/imagem_qr.dart';
import '../functions/opt_prefs.dart';

class TelaGeradorTexto extends StatefulWidget {
  static Widget make() => const TelaGeradorTexto();

  const TelaGeradorTexto({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TelaGeradorTextoState();
}

class _TelaGeradorTextoState extends State<TelaGeradorTexto> {
  String textoEntrada = "";
  String textoQR = "";
  String etiqueta = "";

  @override
  void initState(){
    super.initState();
    // pegar o texto anterior do sharedprefs
    SharedPreferences.getInstance().then( (instance) {
      setState((){
        textoQR =  ler<String>(instance,"texto-qr","");
        etiqueta = ler<String>(instance,"texto-etiqueta","");
      });
    });
  }

  @override
  void dispose(){
    _salvarPrefs();
    super.dispose(); 
  }

  void _salvarPrefs(){
    // guardar os dois valores de uma vez só.
    SharedPreferences.getInstance().then( (instance){
      instance.setString("texto-qr",textoQR);
      instance.setString("texto-etiqueta",etiqueta);
    });
  }

  void _gerarQR(){
    setState(
      (){
        
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: titulo(context,"Gerar QR de texto"),
        resizeToAvoidBottomInset: true,
        body: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children:[
                  ImagemQR(
                    etiqueta: etiqueta,
                    data: textoQR,
                    podeCompartilhar: true,
                    textoOculto: true
                  ),
                  Column(
                    children:[
                      EntradaTexto(hint: "Etiqueta do QR", inicial: etiqueta,
                        onChanged: (t) => etiqueta = t,
                      ),
                      EntradaTexto(hint: "Texto para transformar em QR",inicial: textoQR, maxLines: 10,
                          onChanged: (t) => textoQR = t,
                      ),
                    ]
                  ),
                  BotaoGrande(texto: "Gerar!", onPressed: () { 
                      _gerarQR();
                      mostrarDica("Toque no QR code e segure para compartilhar!", context);
                    } ,)
                ]
              )
            )
          )
        );
  }
}
