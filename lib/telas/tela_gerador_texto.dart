import 'dart:developer';

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
  String textoQR = "";
  String etiqueta = "";

  final _formKey = GlobalKey<FormState>();
  
  final controllerEtiqueta = TextEditingController();
  final controllerQR = TextEditingController();

  @override
  void initState(){
    super.initState();

    // pegar o texto anterior do sharedprefs
    SharedPreferences.getInstance().then( (instance) {
        controllerQR.text =  ler<String>(instance,"texto-qr","");
        controllerEtiqueta.text = ler<String>(instance,"texto-etiqueta","");
        setState((){
          etiqueta = controllerEtiqueta.text;
          textoQR = controllerQR.text;
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
                  Form(
                    key: _formKey,
                    child:Column(
                      children:[
                        EntradaTexto(hint: "Etiqueta do QR", controller: controllerEtiqueta),
                        EntradaTexto(hint: "Texto para transformar em QR",controller: controllerQR, maxLines: 10),
                      ]
                    )
                  )
                  ,
                  BotaoGrande(texto: "Gerar!", 
                    onPressed: () { 
                      if(_formKey.currentState!.validate()){
                        setState((){
                          textoQR = controllerQR.text;
                          etiqueta = controllerEtiqueta.text;
                        });
                        mostrarDica("Toque no QR code e segure para compartilhar!",context);
                      }
                    } 
                  )
                ]
              )
            )
          )
        );
  }
}
