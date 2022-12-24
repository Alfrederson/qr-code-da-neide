/*
 __  _____  _____ _   __                      
/  ||  _  ||  _  (_) / /                      
`| || |/' || |/' |  / /                       
 | ||  /| ||  /| | / /                        
_| |\ |_/ /\ |_/ // / _                       
\___/\___/  \___//_/ (_)                      
                                                                                          
 _____                   _          _   _   _ 
/  ___|                 | |        | | | | (_)
\ `--. _ __   __ _  __ _| |__   ___| |_| |_ _ 
 `--. \ '_ \ / _` |/ _` | '_ \ / _ \ __| __| |
/\__/ / |_) | (_| | (_| | | | |  __/ |_| |_| |
\____/| .__/ \__,_|\__, |_| |_|\___|\__|\__|_|
      | |           __/ |                     
      |_|          |___/                      
 _____           _                            
/  __ \         | |                           
| /  \/ ___   __| | ___                       
| |    / _ \ / _` |/ _ \                      
| \__/\ (_) | (_| |  __/                      
 \____/\___/ \__,_|\___|                      
                                              

Mas é porque eu ainda estou aprendendo Flutter, tá?
*/

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_reader/actions/mostrar_dica.dart';
import 'package:qr_reader/component/botao_grande.dart';
import 'package:qr_reader/component/entrada_chave_pix.dart';
import 'package:qr_reader/component/titulo.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../component/imagem_qr.dart';
import '../component/entrada_texto.dart';

import '../functions/gerar_br_code.dart';
import '../functions/opt_prefs.dart';





class TelaGeradorPix extends StatefulWidget{
  const TelaGeradorPix({Key? key}) : super(key:key);
  static Widget make() => const TelaGeradorPix();

  @override
  State<StatefulWidget> createState() => _TelaGeradorPixState();
}

class _TelaGeradorPixState extends State<TelaGeradorPix>{

  final ctrlEtiqueta = TextEditingController();
  final ctrlNome = TextEditingController();
  final ctrlCidade = TextEditingController();
  final ctrlChave = TextEditingController();
  final ctrlValor = TextEditingController();

  String etiqueta = "";
  String nome = "";
  String cidade ="";
  String tipoChave = "";

  String chaveCPF = "";
  String chaveCelular = "";
  String chaveEmail = "";
  String chaveAleatoria = "";
  double valor = 0.00;
  String brCode = "";

  final _formKey = GlobalKey<FormState>();

  void _atualizaChave(String? s){
    // isso viola 30 princípios diferentes.
    // quando s é nulo, altera o texto do controller.
    // quando s tem algum valor, altera o valor da chave temporária
    // quando eu saio da telinha, eu salvo os valores temporários pra 
    // pessoa já ter os dados entrados.
    // podia ter duas funções diferentes?
    // sim!
    // ah , e se eu tivesse 300 tipos diferentes de chave?
    // aí eu ia usar um mapa ao invés do switch.
    if(s == null){
      switch(tipoChave){
        case "cpf"       : ctrlChave.text = chaveCPF; break;
        case "celular"   : ctrlChave.text = chaveCelular; break;
        case "email"     : ctrlChave.text = chaveEmail; break;
        case "aleatoria" : ctrlChave.text = chaveAleatoria; break;
      }
    }else{
      log("Atualizando chave temporaria para $s");
      switch(tipoChave){
        case "cpf"       : chaveCPF = s; break;
        case "celular"   : chaveCelular = s; break;
        case "email"     : chaveEmail = s; break;
        case "aleatoria" : chaveAleatoria = s; break;
      }
    }
  }

  Future<void> _carregarPrefs(){
    return SharedPreferences.getInstance().then( (prefs){
      // provavelmente não é bom fazer desse jeito.
      ctrlEtiqueta.text =  ler<String>(prefs,"qr-pix-etiqueta","");
      ctrlNome.text =      ler<String>(prefs,"qr-pix-nome","");
      ctrlCidade.text =    ler<String>(prefs,"qr-pix-cidade","");
      ctrlValor.text =     ler<String>(prefs,"qr-pix-valor","");

      tipoChave      = ler<String>(prefs,"qr-pix-tipo","cpf");
      chaveCPF       = ler<String>(prefs,"qr-pix-cpf","");
      chaveCelular   = ler<String>(prefs,"qr-pix-celular","");
      chaveEmail     = ler<String>(prefs,"qr-pix-email","");
      chaveAleatoria = ler<String>(prefs,"qr-pix-aleatoria","");

      _atualizaChave(null);
    });
  }

  void _salvarPrefs(){
    SharedPreferences.getInstance().then( (prefs){
      prefs.setString("qr-pix-etiqueta" ,ctrlEtiqueta.text);
      prefs.setString("qr-pix-nome"     ,ctrlNome.text);
      prefs.setString("qr-pix-cidade"   ,ctrlCidade.text);

      prefs.setString("qr-pix-tipo"     ,tipoChave);
      prefs.setString("qr-pix-cpf"      ,chaveCPF);
      prefs.setString("qr-pix-celular"  ,chaveCelular);
      prefs.setString("qr-pix-email"    ,chaveEmail);
      prefs.setString("qr-pix-aleatoria",chaveAleatoria);

      prefs.setString("qr-pix-valor"    ,ctrlValor.text);
    });
  }

  // essa função acaba sendo rodada 5 vezes, uma pra cada campo.
  void _gerarBRCode(){
    // salva o que a pessoa botou.
    // isso vou fazer com validade, na verdade.
    valor = double.tryParse(ctrlValor.text) ?? 0.01;
    setState((){
      brCode = gerarBRCode(nome: ctrlNome.text,
                           cidade: ctrlCidade.text,
                           chave: ctrlChave.text,
                           valor: valor,
                           codigo: "Transacao");
    });  
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (x) async {
      await _carregarPrefs();
      _gerarBRCode();
    });
  }
  @override
  void dispose(){
    _salvarPrefs();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: titulo(context,"Plaquinha de PIX"),
      resizeToAvoidBottomInset: true,
      body:Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child:
        Column(children:[
          ImagemQR(data: brCode, etiqueta: ctrlEtiqueta.text, podeCompartilhar: true,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                EntradaTexto( hint: "Nome (sem acentos)", controller: ctrlNome, tipo: EntradaTextoTipo.campoPix),
                EntradaTexto( hint: "Cidade (sem acentos)",controller: ctrlCidade, tipo: EntradaTextoTipo.campoPix),
                EntradaChavePix(
                  hint: ((){
                    switch(tipoChave){
                      case "cpf": return "CPF sem pontos ou traços" ;
                      case "celular" : return "+55(DDD)(NUMERO)";
                      case "email" : return "E-mail";
                      case "aleatoria" : return "Chave aleatória";
                      default: return "Sei lá";
                  }})(),
                  tipoChave: tipoChave,
                  controller: ctrlChave,
                  onChanged: (chave) => _atualizaChave(chave),
                  onMudouTipo: (tipo){ 
                      setState((){
                        tipoChave = tipo ?? "cpf";
                        _atualizaChave(null);
                      }
                    );
                  }
                ),
                EntradaTexto(
                  hint: "Valor",
                  controller: ctrlValor,
                  tipo: EntradaTextoTipo.numerico,
                ),
                EntradaTexto(
                  hint: "Etiqueta",
                  controller: ctrlEtiqueta,
                )
              ]
            )
          ),
          BotaoGrande(texto: "Gerar!", onPressed: () {
            if(_formKey.currentState!.validate()){
              _gerarBRCode();
              mostrarDica("Toque no QR Code e segure para compartilhar!",context);
            }
          },)
        ])
        )
      )
    );
  }

}