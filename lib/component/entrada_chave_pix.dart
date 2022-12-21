import 'package:flutter/material.dart';
import 'package:qr_reader/component/entrada_texto.dart';


/*
  Sim, isso aqui é copiado e colado do outro componente.
  No presente momento não quero pensar em como generalizar.
*/

void vazia(String? s){}

class EntradaChavePix extends StatefulWidget{
  final String hint;
  final String tipoChave;
  final String inicial;
  final Function(String?) onMudouTipo;
  final Function(String?) onChanged;
  final Function(String?) onFinished;
  final int maxLines;
  late final TextEditingController controller;

  EntradaChavePix({super.key,
      this.hint="",
      this.tipoChave = "cpf",
      this.inicial = "",
      this.onChanged=vazia,
      this.onFinished=vazia,
      this.onMudouTipo=vazia,
      this.maxLines=1}){
    
    controller = TextEditingController(text: inicial);

  }
  @override
  State<EntradaChavePix> createState() => _EntradaChavePixState();
}

class _EntradaChavePixState extends State<EntradaChavePix> {
  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical : 10),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            DropdownButton(
                value: widget.tipoChave.isEmpty ? "cpf" : widget.tipoChave,
                items: const[
                  DropdownMenuItem(value: "cpf"      ,child: Text("CPF")),
                  DropdownMenuItem(value: "celular"  ,child: Text("Celular")),
                  DropdownMenuItem(value: "email"    ,child: Text("Email")),
                  DropdownMenuItem(value: "aleatoria",child: Text("Aleatoria")),
                ],
                onChanged: widget.onMudouTipo
                ),
            const SizedBox(width:10),
            Expanded(child: TextFormField(
                controller: widget.controller,
                maxLines: 1,
                keyboardType: TextInputType.text,
                style: const EntradaTextoStyle(),
                decoration: EntradaTextoDecoration(widget.hint),
                onChanged: widget.onChanged
              )
            ) 
          ]
    )

    );
    
  }
}
