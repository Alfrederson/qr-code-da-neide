import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class BannerAnuncio extends StatefulWidget{
  final AdSize tamanho;
  final double? largura;
  final double? altura;
  final Function? adCarregado;

  const BannerAnuncio({super.key , this.tamanho = AdSize.largeBanner, this.largura, this.altura, this.adCarregado});

  @override
  State<StatefulWidget> createState() => _BannerAnuncioState();
}

class _BannerAnuncioState extends State<BannerAnuncio>{
  static var adUnitID = "";


  AdManagerBannerAd? _ad;

  // vou escolher o tamanho com base no valor do 
  // enum e estou 100% nem aí
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.tamanho.height > 0 ? widget.tamanho.height * 1.0 : widget.altura,
      width: widget.tamanho.width > 0 ?  widget.tamanho.width * 1.0 : widget.largura,
      child: _ad != null ? 
              AdWidget(ad : _ad!) : 
              SizedBox(
                height: widget.tamanho.height > 0 ? widget.tamanho.height * 1.0 : widget.altura, 
              )
    );
  }

  @override
  void dispose(){
    super.dispose();
    _ad?.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(adUnitID.isEmpty){
      log("Obtendo AD_UNIT_ID");
      adUnitID = FlutterConfig.get("ADMOB_AD_UNIT_ID");
      log("Obtido: $adUnitID");
    }
    _ad = AdManagerBannerAd(
      sizes: [widget.tamanho],
      adUnitId: adUnitID,
      request: const AdManagerAdRequest(nonPersonalizedAds: true),
      listener: AdManagerBannerAdListener(
        onAdLoaded: (Ad ad){
          
          log("$ad carregado. Chamando callback pra liberar.");
          if(widget.adCarregado != null){
            widget.adCarregado!();
          }           
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error){
          log("$ad não carregou: $error. Chamando callback pra não irritar o usuário que pode estar sem internet.");
          if(widget.adCarregado != null){
            widget.adCarregado!();
          }          
          ad.dispose();
        },
        onAdOpened: (Ad ad) => log("$ad aberto"),
        onAdClosed: (Ad ad) => log("$ad fechado")
      )
    )..load();
  }

}