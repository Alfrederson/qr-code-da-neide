import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntradaTextoDecoration extends InputDecoration{
  EntradaTextoDecoration(String texto) : super(
    labelText : texto,
    contentPadding: const EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10)
    )
  );
}

class EntradaTextoStyle extends TextStyle{
  const EntradaTextoStyle() : super(
    fontSize: 20,
    fontFamily: "Monospace"
  );
}

enum EntradaTextoTipo{
  qualquer,
  campoPix,
  numerico
}


class EntradaTexto extends StatefulWidget{
  final String hint;
  final Function(String)? onChanged;
  final Function(String)? onFinished;
  final TextEditingController? controller ;
  final String? Function(String?)? validador;
  final int maxLines;
  final EntradaTextoTipo tipo;
    
  const EntradaTexto({super.key,
    required this.hint,
    this.onChanged,
    this.onFinished,
    this.controller,
    this.maxLines=1,
    this.tipo=EntradaTextoTipo.qualquer,
    this.validador});

  @override
  State<EntradaTexto> createState() => _EntradaTextoState();
}

class _EntradaTextoState extends State<EntradaTexto> {
  late TextEditingController controller ;
  late TextInputType inputType;
  double valorAnterior = 0.0;

  bool temFoco=false;
  @override
  void initState(){
    super.initState();
    controller = widget.controller ?? TextEditingController();

    log("Inicializando. Valora agora é ${controller.text}");
      
    if (widget.tipo == EntradaTextoTipo.numerico) {
      inputType =
        const TextInputType.numberWithOptions(signed: false, decimal: true);
    } else if (widget.maxLines > 1) {
      inputType = TextInputType.multiline;
    } else {
      inputType = TextInputType.text;
    }

  }

  void _checarFormato(){
    if(widget.tipo == EntradaTextoTipo.numerico){
      controller.text = controller.text.replaceAll(",", ".");
      double v;

      v = double.tryParse(controller.text) ?? valorAnterior;
      controller.text = v.toStringAsFixed(2);
      valorAnterior = v;
      
      if(temFoco) controller.selection = TextSelection.collapsed(offset: controller.text.length);              
    }
  }

  String? validador(String? valor){
    if(valor == null || valor.trim().isEmpty) return "Preencha, por obséquio";
    if(widget.tipo == EntradaTextoTipo.numerico){
      double v;
      v = double.tryParse(valor) ?? double.nan;
      if(v.isNaN) return "Coloque um valor válido, por obséquio";
      if(v <= 0.01) return "Coloque um valor maior que 1 centavo, por obséquio";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Focus(
          onFocusChange: ((hasFocus) {
            temFoco = hasFocus;
            if(!hasFocus){
              _checarFormato();
            }
          }),
          child: TextFormField(
                    validator: validador,
                    controller: controller,
                    keyboardType: inputType,
                    style: const EntradaTextoStyle(),
                    maxLines: widget.maxLines,
                    decoration: EntradaTextoDecoration(widget.hint),
                    onChanged: (s){
                      if(widget.onChanged != null) widget.onChanged!(s);
                    },
                    onEditingComplete: _checarFormato,
                ),  
        )
        );
  }
}