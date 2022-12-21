import 'package:flutter/material.dart';

class BotaoHorizontal extends StatelessWidget{
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final String texto;

  const BotaoHorizontal(this.texto, {super.key, this.onPressed, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Text(texto, 
                    style: const TextStyle(fontSize: 32),
                    textAlign: TextAlign.left),
      )
    );
  }

}