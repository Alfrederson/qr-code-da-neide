import 'package:flutter/material.dart';

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

//ignore: must_be_immutable
class EntradaTexto extends StatefulWidget{
  late String hint;
  late String inicial;
  late Function(String)? onChanged;
  late Function(String)? onFinished;
  late String? Function(String?)? validador;
  late int maxLines;
  late bool numerico;
  late TextEditingController controller;
    
  EntradaTexto({super.key,
    required this.hint,
    this.onChanged,
    this.onFinished,
    this.inicial="",
    this.maxLines=1,
    this.numerico=false,
    this.validador}){
      controller = TextEditingController(text: inicial);
  }
  @override
  State<EntradaTexto> createState() => _EntradaTextoState();
}

class _EntradaTextoState extends State<EntradaTexto> {
  
  @override
  Widget build(BuildContext context) {
    TextInputType inputType;
    
    if (widget.numerico) {
      inputType =
          const TextInputType.numberWithOptions(signed: false, decimal: true);
    } else if (widget.maxLines > 1) {
      inputType = TextInputType.multiline;
    } else {
      inputType = TextInputType.text;
    }

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          validator: widget.validador,
          controller: widget.controller,
          keyboardType: inputType,
          style: const EntradaTextoStyle(),
          maxLines: widget.maxLines,
          decoration: EntradaTextoDecoration(widget.hint),
          onChanged: (s){
            if(widget.onChanged != null) widget.onChanged!(s);
          }
        ));
  }
}
