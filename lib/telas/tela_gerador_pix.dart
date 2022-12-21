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
  String etiqueta = "";
  String nome = "";
  String cidade ="";
  String tipoChave = "";
  String chave = "";

  String chaveCPF = "";
  String chaveCelular = "";
  String chaveEmail = "";
  String chaveAleatoria = "";
  double valor = 0.00;
  String brCode = "";

  final _formKey = GlobalKey<FormState>();

  void _atualizaChave(String? s){
    // isso é horrível
    // não faça muitas vezes por segundo.
    if(s == null){
      switch(tipoChave){
        case "cpf": chave = chaveCPF; break;
        case "celular" : chave = chaveCelular; break;
        case "email" : chave = chaveEmail; break;
        case "aleatoria" : chave = chaveAleatoria; break;
      }
    }else{
      switch(tipoChave){
        case "cpf": chaveCPF = s; break;
        case "celular" : chaveCelular = s; break;
        case "email" : chaveEmail = s; break;
        case "aleatoria" : chaveAleatoria = s; break;
      }
      chave =s;
    }
  }

  Future<void> _carregarPrefs(){
    return SharedPreferences.getInstance().then( (prefs){
      // provavelmente não é bom fazer desse jeito.
      etiqueta =  ler<String>(prefs,"qr-pix-etiqueta","");
      nome =      ler<String>(prefs,"qr-pix-nome","");
      cidade =    ler<String>(prefs,"qr-pix-cidade","");
      tipoChave = ler<String>(prefs,"qr-pix-tipo","cpf");
      chaveCPF  = ler<String>(prefs,"qr-pix-cpf","");
      chaveCelular = ler<String>(prefs,"qr-pix-celular","");
      chaveEmail   = ler<String>(prefs,"qr-pix-email","");
      chaveAleatoria = ler<String>(prefs,"qr-pix-aleatoria","");
      valor = ler<double>(prefs,"qr-pix-valor",0.0);
      _atualizaChave(null);
    });
  }

  void _salvarPrefs(){
    SharedPreferences.getInstance().then( (prefs){
      prefs.setString("qr-pix-etiqueta",etiqueta);
      prefs.setString("qr-pix-nome", nome);
      prefs.setString("qr-pix-cidade", cidade);
      prefs.setString("qr-pix-tipo", tipoChave);
      prefs.setString("qr-pix-cpf", chaveCPF);
      prefs.setString("qr-pix-celular", chaveCelular);
      prefs.setString("qr-pix-email", chaveEmail);
      prefs.setString("qr-pix-aleatoria", chaveAleatoria);
      prefs.setDouble("qr-pix-valor", valor);
    });
  }

  // essa função acaba sendo rodada 5 vezes, uma pra cada campo.
  Future<bool> _gerarBRCode() async {
    // salva o que a pessoa botou.
    if(nome.isEmpty)return false;
    if(cidade.isEmpty) return false;
    if(chave.isEmpty) return false;
    if(valor <= 0.01) return false;

    log("Gerando.");

    setState((){
      brCode = gerarBRCode(nome: nome,
                          cidade: cidade,
                          chave: chave,
                          valor: valor,
                          codigo: "Transacao");
    });

    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback( (x) async {
      await _carregarPrefs();
      setState((){
        _gerarBRCode();
      });
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
          ImagemQR(data: brCode, etiqueta: etiqueta, podeCompartilhar: true,),
          Form(
            key: _formKey,
            child: Column(
              children: [
                EntradaTexto( hint: "Nome (sem acentos)", inicial: nome, onChanged: (s) =>  nome = s),
                EntradaTexto( hint: "Cidade (sem acentos)",inicial: cidade, onChanged: (s) =>  cidade = s),
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
                  inicial: chave,
                  onChanged: _atualizaChave,
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
                  inicial: valor.toStringAsFixed(2),
                  numerico: true,
                  onChanged: (s) {
                    try{
                      valor = double.parse(s);
                    }catch(e){
                      valor = 0.0;
                    }
                  }
                ),
                EntradaTexto(
                  hint: "Etiqueta",
                  inicial: etiqueta,
                  onChanged: (s) => etiqueta = s,
                )
              ]
            )
          ),
          BotaoGrande(texto: "Gerar!", onPressed: () {
            if(_formKey.currentState!.validate()){
              _gerarBRCode().then( (resultado) =>
                mostrarDica(
                  resultado ? 
                    "Toque no QR code e segure para compartilhar!" :
                    "Tem alguma coisa errada nos dados fornecidos!",
                  context)
              );
            }
          },)
        ])
        )
      )
    );
  }

}