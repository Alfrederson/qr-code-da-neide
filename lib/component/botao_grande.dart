import 'package:flutter/material.dart';

class BotaoGrande extends StatelessWidget{
  final void Function()? onPressed;
  final void Function()? onLongPress;

  final String texto;
  const BotaoGrande({super.key, required this.texto, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child:
        TextButton(
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withAlpha(25),

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            minimumSize: const Size.fromHeight(64),
            alignment: const Alignment(0,0)
          ),
          child: Text(texto, textAlign: TextAlign.center, style: const TextStyle(fontFamily: "Courier",fontSize:24, fontWeight: FontWeight.bold))
      )
    );
  }
}